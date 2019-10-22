class AddShipmentsAndImagesBooleansToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :images, :boolean
    add_column :users, :shipments, :boolean
  end
end
