# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts, id: false do |t|
      t.string :id, primary_key: true, unique: true
      t.string :external_id, unique: true
      t.string :name

      t.timestamps
    end
  end
end
