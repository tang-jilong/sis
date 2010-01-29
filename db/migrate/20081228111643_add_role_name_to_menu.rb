class AddRoleNameToMenu < ActiveRecord::Migration
  def self.up
    add_column :menus, :role_name, :string
  end

  def self.down
    remove_column :menus, :role_name
  end
end
