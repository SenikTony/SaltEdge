class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :account
      t.string :transaction_id
      t.string :made_on
      t.string :category
      t.string :description
      t.string :currency_code
      t.decimal :amount, precision: 24, scale: 12
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
