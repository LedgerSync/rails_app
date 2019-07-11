class CreateSyncLedgers < ActiveRecord::Migration[5.2]
  def change
    create_table :sync_ledgers, id: false do |t|
      t.string :id, primary_key: true, unique: true
      t.belongs_to :sync, foreign_key: true, type: :string
      t.belongs_to :ledger, foreign_key: true, type: :string
      t.integer :status, default: 0, null: false, index: true

      t.timestamps
    end

    add_index :sync_ledgers, %i[sync_id ledger_id], unique: true
  end
end
