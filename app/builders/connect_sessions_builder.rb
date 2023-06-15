class ConnectSessionsBuilder
  def self.build(**args)
    new(**args).build
  end

  attr_reader :user, :errors, :connect_session_url, :callback_url

  def initialize(user:, callback_url:)
    @user = user
    @connect_session_url = ""
    @callback_url = callback_url
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

    gateway_data = Gateway::ConnectSessions::CreateService.call(user: user, callback_url: callback_url)
    @errors << gateway_data[:error][:message] if gateway_data.key?(:error)
    return false if @errors.size.positive?

    @connect_session_url = gateway_data[:data][:connect_url]
    true
  rescue StandardError => e
    @errors << e.message
    return false
  end
end