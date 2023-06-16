class AccountsListBuilder
  def self.build(**args)
    new(**args).build
  end

  attr_reader :user, :errors, :from_id, :connection, :accounts

  def initialize(user:, connection:, from_id: "")
    @user = user
    @connection = connection
    @from_id = from_id
    @errors = []
  end

  def valid?
    @errors.clear
    @errors << "User must be defined" if user.blank? || !user.persisted?
    @erorrs << "User do not have gateway credentials" unless user.gateway_user?

    unless user.connections.include?(connection)
      @erorrs << "Connection with ID #{connection.connection_id} does not belong to the user"
    end

    @errors.size.zero?
  end

  def build
    return false unless valid?

    gateway_data = Gateway::Accounts::ListService.call(connection: connection, from_id: from_id)
    @errors << gateway_data[:error][:message] if gateway_data.key?(:error)
    return false if @errors.size.positive?

    # TODO: If we have filled meta key then we need start worker to grab more acoounts

    sync_gateway_connection_accounts(gateway_data[:data])
  rescue StandardError => e
    @errors << e.message
    return false
  ensure
    @accounts = connection.accounts
  end

  private

  def sync_gateway_connection_accounts(data)
    data&.each do |gateway_account|
      account = connection.accounts.find_or_initialize_by(account_id: gateway_account[:id])
      account.name = gateway_account[:name]
      account.nature = gateway_account[:nature]
      account.balance = gateway_account[:balance]
      account.currency_code = gateway_account[:currency_code]
      account.save
    rescue StandardError => _e
      @errors << "Can't create/update account #{gateway_account[:id]} for connection #{connection.connection_id}"
    end
  end
end
