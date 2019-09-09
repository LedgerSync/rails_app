class ChangeAuthTokensForResource < ActiveRecord::Migration[5.2]
  def up
    add_column :auth_tokens, :resource_type, :string
    remove_foreign_key :auth_tokens, :users
    rename_column :auth_tokens, :user_id, :resource_id
    add_index :auth_tokens, %w[resource_id resource_type]

    AuthToken.reset_column_information

    AuthToken.update_all(resource_type: 'User')
  end

  def down
    remove_column :auth_tokens, :resource_type
    rename_column :auth_tokens, :resource_id, :user_id
    add_foreign_key :auth_tokens, :users
  end
end
