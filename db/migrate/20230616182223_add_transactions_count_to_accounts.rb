class AddTransactionsCountToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :transactions_count, :integer
  end
end
