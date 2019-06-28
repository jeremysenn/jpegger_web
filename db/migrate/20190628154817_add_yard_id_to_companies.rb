class AddYardIdToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :yard_id, :string
  end
end
