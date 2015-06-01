class AddAdminToUsers < ActiveRecord::Migration
  def change
    # By default, users are not admins
    add_column :users, :admin, :boolean, default: false
  end
end

# Rails will automatically add the method admin? because admin is a boolean
