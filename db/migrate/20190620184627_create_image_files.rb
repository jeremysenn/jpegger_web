class CreateImageFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :image_files do |t|
      t.string :name
      t.string :file
      t.integer :user_id
      t.string :ticket_number
      t.string :customer_number
      t.string :customer_name
      t.string :branch_code
      t.string :location
      t.string :event_code
      t.integer :event_code_id
      t.integer :image_id
      t.string :container_number
      t.string :booking_number
      t.string :contract_number
      t.boolean :hidden
      t.string :tare_seq_nbr
      t.string :commodity_name
      t.decimal :weight
      t.string :tag_number
      t.string :vin_number
      t.string :yard_id
      t.string :contract_verbiage
      t.string :service_request_number
      
      t.timestamps null: false
    end
  end
end