class TransactionsListBuilder
  def self.build(**args)
    new(**args).build
  end

  attr_reader :user, :errors, :from_id, :account, :transactions

  def initialize(user:, account:, from_id: "")
    @user = user
    @account = account
    @from_id = from_id
    @errors = []
  end

  def valid?
    @errors.clear
    @errors << "User must be defined" if user.blank? || !user.persisted?
    @erorrs << "User do not have gateway credentials" unless user.gateway_user?

    unless user.accounts.include?(account)
      @erorrs << "Account with ID #{account.account_id} does not belong to the user"
    end

    @errors.size.zero?
  end

  def build
    return false unless valid?

    gateway_data_posted = Gateway::Transactions::ListService.call(connection: account.connection, account: account, from_id: from_id)
    @errors << gateway_data_posted[:error][:message] if gateway_data_posted.key?(:error)
    return false if @errors.size.positive?

    sync_gateway_account_transactions(gateway_data_posted[:data])

    gateway_data_pending = Gateway::Transactions::ListService.call(connection: account.connection, account: account, status: :pending, from_id: from_id)
    @errors << gateway_data_pending[:error][:message] if gateway_data_pending.key?(:error)

    # TODO: If we have filled meta key then we need start worker to grab more acoounts

    sync_gateway_account_transactions(gateway_data_pending[:data], true)
  rescue StandardError => e
    @errors << e.message
    return false
  ensure
    @transactions = account.transactions
  end

  private

  def sync_gateway_account_transactions(data, pending = false)
    account.transactions.pending.destroy_all if pending

    data&.each do |gateway_transaction|
      transaction = account.transactions.find_or_initialize_by(transaction_id: gateway_transaction[:id])
      transaction.made_on = gateway_transaction[:made_on]
      transaction.category = gateway_transaction[:category]
      transaction.description = gateway_transaction[:description]
      transaction.currency_code = gateway_transaction[:currency_code]
      transaction.amount = gateway_transaction[:amount]
      transaction.status = gateway_transaction[:status].to_s
      transaction.save
    rescue StandardError => _e
      @errors << "Can't create/update transaction #{gateway_transaction[:id]} for account #{account.account_id}"
    end
  end
end
