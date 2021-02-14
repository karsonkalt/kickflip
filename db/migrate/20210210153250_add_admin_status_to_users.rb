class AddAdminStatusToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin_status, :boolean, :default => false
  end
end
