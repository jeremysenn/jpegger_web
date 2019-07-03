class AddCameraClassAndCameraPositionToImageFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :image_files, :camera_class, :string
    add_column :image_files, :camera_position, :string
  end
end
