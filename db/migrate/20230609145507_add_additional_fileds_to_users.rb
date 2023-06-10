class AddAdditionalFiledsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :gateway_id, :bigint
    add_column :users, :gateway_identifier, :string
    add_column :users, :gateway_secret, :string
    add_column :users, :gateway_blocked_at, :datetime
  end
end
