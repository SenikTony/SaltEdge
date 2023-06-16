class AddAccountsCountToConnections < ActiveRecord::Migration[7.0]
  def change
    add_column :connections, :accounts_count, :integer
  end
end
