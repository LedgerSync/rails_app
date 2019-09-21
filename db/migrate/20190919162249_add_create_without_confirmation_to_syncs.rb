class AddCreateWithoutConfirmationToSyncs < ActiveRecord::Migration[5.2]
  def change
    add_column :syncs, :without_create_confirmation, :boolean
  end
end
