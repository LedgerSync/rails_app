class CreateAccountUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :account_users do |t|
      t.belongs_to :account, foreign_key: true, type: :string
      t.belongs_to :user, foreign_key: true, type: :string

      t.timestamps
    end

    add_index :account_users, %i[user_id account_id], unique: true
  end
end
