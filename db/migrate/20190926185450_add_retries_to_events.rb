class AddRetriesToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :retries, :integer
  end
end
