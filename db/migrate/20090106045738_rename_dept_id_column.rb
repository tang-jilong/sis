class RenameDeptIdColumn < ActiveRecord::Migration
  def self.up
    rename_column :users, :dept_id, :department_id
  end

  def self.down
    rename_column :users, :department_id, :dept_id
  end
end
