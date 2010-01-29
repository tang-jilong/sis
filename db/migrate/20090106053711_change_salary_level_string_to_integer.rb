class ChangeSalaryLevelStringToInteger < ActiveRecord::Migration
  def self.up
    
    change_column :users, :salary_level_id, :integer
  end

  def self.down
    change_column :users, :salary_level_id, :string
  end
end
