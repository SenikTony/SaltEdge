class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|
      t.belongs_to :user

      t.string :connection_id
      t.string :provider_name
      t.numeric :status, default: 0, null: false
      t.datetime :balance_updated_at
 
      t.timestamps
    end
  end
end
