class AddPositionToSyncs < ActiveRecord::Migration[5.2]
  def change
    add_column :syncs, :position, :serial, null: false, unique: true
  end
end
