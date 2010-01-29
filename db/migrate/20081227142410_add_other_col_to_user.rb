class AddOtherColToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :hr_id, :string
    add_column :users, :work_id, :string
    add_column :users, :salary_point, :string
    add_column :users, :grade_assess_level, :string
    add_column :users, :remark, :text
  end

  def self.down
    remove_column :users, :remark
    remove_column :users, :grade_assess_level
    remove_column :users, :salary_point
    remove_column :users, :work_id
    remove_column :users, :hr_id
  end
end
