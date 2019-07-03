class AddLeadsOnlineBooleanAndLeadsOnlineStoreIdToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :leads_online, :boolean
    add_column :companies, :leads_online_store_id, :string
  end
end
