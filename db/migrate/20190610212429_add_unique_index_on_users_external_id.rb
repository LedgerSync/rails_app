class AddUniqueIndexOnUsersExternalID < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :external_id, unique: true
  end
end
