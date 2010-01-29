class AddRoleIdDeptIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :role_id, :integer
    add_column :users, :dept_id, :integer
  end

  def self.down
    remove_column :users, :dept_id
    remove_column :users, :role_id
  end
end
