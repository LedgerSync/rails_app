class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events, id: :string do |t|
      t.string :type, index: true
      t.text :data
      t.string :event_object_id
      t.string :event_object_type
      t.references :organization, index: true


      t.timestamps
    end

    add_index :events, [:event_object_id, :event_object_type]
  end
end
