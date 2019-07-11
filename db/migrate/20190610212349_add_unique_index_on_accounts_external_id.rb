class AddUniqueIndexOnAccountsExternalID < ActiveRecord::Migration[5.2]
  def change
    add_index :accounts, :external_id, unique: true
  end
end
