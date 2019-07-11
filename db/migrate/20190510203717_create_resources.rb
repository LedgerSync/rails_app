class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources, id: false do |t|
      t.string :id, primary_key: true, unique: true
      t.string :external_id
      t.string :type
      t.string :account_id, type: :string, index: true

      t.timestamps
    end
    add_foreign_key :resources, :accounts
    add_index :resources, %i[external_id type], unique: true
  end
end
