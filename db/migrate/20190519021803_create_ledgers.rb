class CreateLedgers < ActiveRecord::Migration[5.2]
  def change
    create_table :ledgers, id: false do |t|
      t.string :id, primary_key: true, unique: true
      t.string :kind
      t.belongs_to :account, foreign_key: true, type: :string
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at
      t.jsonb :data
      t.string :connected_by, index: true
      t.string :disconnected_by, index: true
      t.datetime :disconnected_at, index: true

      t.timestamps
    end

    add_foreign_key :ledgers, :users, column: :connected_by
    add_foreign_key :ledgers, :users, column: :disconnected_by
  end
end
