class CreateSyncs < ActiveRecord::Migration[5.2]
  def change
    create_table :syncs, id: false do |t|
      t.string :id, primary_key: true, unique: true
      t.belongs_to :account, foreign_key: true, type: :string
      t.belongs_to :resource, foreign_key: true, type: :string
      t.string :resource_type
      t.string :resource_external_id
      t.string :operation_method
      t.jsonb :references
      t.integer :status, default: 0, null: false, index: true
      t.text :status_message
      t.string :fingerprint

      t.timestamps
    end
  end
end
