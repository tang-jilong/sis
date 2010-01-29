class CreateSalaryLevels < ActiveRecord::Migration
  def self.up
    create_table :salary_levels do |t|
      t.string :name
      t.text :remark

      t.timestamps
    end
  end

  def self.down
    drop_table :salary_levels
  end
end
