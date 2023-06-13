class ConnectionsListBuilder
  def self.build(**args)
    new(**args).build
  end

  attr_reader :user, :errors, :from_id, :connections

  def initialize(user:, from_id: "")
    @user = user
    @from_id = from_id
    @errors = []
  end

  def valid?
    @errors.clear
    @errors << "User must be defined" if user.blank? || !user.persisted?
    @erorrs << "User do not have gateway credentials" unless user.gateway_user?

    @errors.size.zero?
  end

  def build
    return false unless valid?

    gateway_data = Gateway::Connections::ListService.call(user: user, from_id: from_id)
    @errors << gateway_data[:error][:message] if gateway_data.key?(:error)
    return false if @errors.size.positive?

    # TODO: If we have filled meta key then we need start worker to grab more connections

    sync_gateway_connections(gateway_data[:data])
  rescue StandardError => e
    @errors << e.message
    return false
  ensure
    @connections = user.reload.connections
  end

  private

  def sync_gateway_connections(data)
    data&.each do |gateway_connection|
      connection = user.connections.find_or_initialize_by(connection_id: gateway_connection[:id]) do |user_connection|
        user_connection.provider_name = gateway_connection[:provider_name]
      end

      connection.status = gateway_connection[:status]
      connection.balance_updated_at = gateway_connection[:updated_at]
      connection.save

    rescue StandardError => _e
      @errors << "Can't craete/update connection #{gateway_connection[:id]}"
    end
  end
end