class CreateSyncLedgerLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :sync_ledger_logs, id: :string do |t|
      t.string :action, null: false, type: :string
      t.references :sync_ledger, foreign_key: true, type: :string
      t.jsonb :data

      t.timestamps
    end
  end
end
