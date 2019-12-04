class CreateShipmentFilesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :shipment_files do |t|
      t.string :name
      t.integer :capture_sequence_number
      t.string :file
      t.integer :user_id
      t.string :ticket_number
      t.string :customer_number
      t.string :customer_name
      t.string :branch_code
      t.string :location
      t.string :event_code
      t.integer :event_code_id
      t.integer :shipment_id
      t.string :container_number
      t.string :booking_number
      t.string :contract_number
      t.boolean :hidden
      t.string :yard_id
      t.string :camera_name
      t.string :camera_group
      
      t.timestamps null: false
    end
  end
end
