class RenameSalaryLevelColumn < ActiveRecord::Migration
   def self.up
    rename_column :users, :salary_level, :salary_level_id
  end

  def self.down
    rename_column :users, :salary_level_id, :salary_level
  end
end
