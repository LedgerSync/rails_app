class CreateAuthTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_tokens, id: false do |t|
      t.string :id, primary_key: true, unique: true
      t.belongs_to :user, foreign_key: true, type: :string
      t.datetime :used_at

      t.timestamps
    end
  end
end
