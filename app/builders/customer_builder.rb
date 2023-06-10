class CustomerBuilder
  def self.build(**args)
    new(**args).build
  end

  attr_reader :user, :errors

  def initialize(user:)
    @user = user
    @errors = []
  end

  def valid?
    @errors.clear
    @errors << "User must be defined" if user.blank?

    @errors.size.zero?
  end

  def build
    return false unless valid?

    gateway_data = Gateway::Customers::CreateService.call(user: user)
    @errors << gateway_data[:error][:message] if gateway_data.key?(:error)
    return false if @errors.size.positive?

    update_user_gateway_data(gateway_data)
  rescue StandardError => e
    @errors << e.message
    Gateway::Customers::RemoveService.call(id: gateway_data[:data][:id])
    return false
  end

  private

  def update_user_gateway_data(gateway_data)
    user.update(
      gateway_id: gateway_data[:data][:id], 
      gateway_identifier: gateway_data[:data][:identifier],
      gateway_secret: gateway_data[:data][:secret],
      gateway_blocked_at: gateway_data[:data][:blocked_at]
    )
  end
end