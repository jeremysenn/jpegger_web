class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :phone
      t.string :jpegger_service_ip, null: false
      t.string :jpegger_service_port, null: false
      
      t.timestamps null: false
    end
  end
end
