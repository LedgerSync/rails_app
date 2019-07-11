# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: false do |t|
      t.string :id, primary_key: true, unique: true
      t.string :external_id, unique: true
      t.string :email
      t.boolean :is_admin
      t.belongs_to :account, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
