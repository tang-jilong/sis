class AddSalaryLevelToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :salary_level, :string
  end

  def self.down
    remove_column :users, :salary_level
  end
end
