class CreateSyncResources < ActiveRecord::Migration[5.2]
  def change
    create_table :sync_resources, id: false do |t|
      t.string :id, primary_key: true, unique: true
      t.belongs_to :sync, foreign_key: true, type: :string
      t.belongs_to :resource, foreign_key: true, type: :string
      t.jsonb :data

      t.timestamps
    end

    add_index :sync_resources, %i[sync_id resource_id], unique: true
  end
end
