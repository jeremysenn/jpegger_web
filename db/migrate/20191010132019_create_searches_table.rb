class CreateSearchesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.integer :user_id
      t.string :table_name
      t.string :event_code
      t.string :customer_name
      t.string :ticket_number
      t.date :start_date
      t.date :end_date
      
      t.timestamps null: false
    end
  end
end
