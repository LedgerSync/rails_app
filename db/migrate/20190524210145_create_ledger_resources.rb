class CreateLedgerResources < ActiveRecord::Migration[5.2]
  def change
    create_table :ledger_resources, id: false do |t|
      t.string :id, primary_key: true, unique: true
      t.belongs_to :ledger, foreign_key: true, type: :string
      t.belongs_to :resource, foreign_key: true, type: :string
      t.string :resource_ledger_id
      t.string :approved_by_id, index: true

      t.timestamps
    end

    add_foreign_key :ledger_resources, :users, column: :approved_by_id
    add_index :ledger_resources, %i[resource_id ledger_id], unique: true
  end
end
