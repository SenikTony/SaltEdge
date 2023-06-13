class AddLastConsentIdToConnections < ActiveRecord::Migration[7.0]
  def change
    add_column :connections, :last_consent_id, :string
  end
end
