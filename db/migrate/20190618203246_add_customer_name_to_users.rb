class AddCustomerNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :customer_name, :string
  end
end
