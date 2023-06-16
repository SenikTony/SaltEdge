class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.belongs_to :connection
      t.string :account_id
      t.string :name
      t.string :nature
      t.decimal :balance, precision: 12, scale: 2
      t.string :currency_code

      t.timestamps
    end
  end
end
