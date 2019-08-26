class RenameAccountToOrganization < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :account_users, :accounts
    rename_column :account_users, :account_id, :organization_id
    remove_foreign_key :ledgers, :accounts
    rename_column :ledgers, :account_id, :organization_id
    remove_foreign_key :resources, :accounts
    rename_column :resources, :account_id, :organization_id
    remove_foreign_key :syncs, :accounts
    rename_column :syncs, :account_id, :organization_id
    remove_foreign_key :users, :accounts
    rename_column :users, :account_id, :organization_id

    rename_table :accounts, :organizations

    add_foreign_key :account_users, :organizations
    add_foreign_key :ledgers, :organizations
    add_foreign_key :resources, :organizations
    add_foreign_key :syncs, :organizations
    add_foreign_key :users, :organizations

    rename_table :account_users, :organization_users
  end
end
