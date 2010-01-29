class AddDeptNameToSalaryInfos < ActiveRecord::Migration
  def self.up
    add_column :salary_infos, :dept_name, :string
  end

  def self.down
    remove_column :salary_infos, :dept_name
  end
end
