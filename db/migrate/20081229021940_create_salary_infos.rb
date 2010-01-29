class CreateSalaryInfos < ActiveRecord::Migration
  def self.up
    create_table :salary_infos do |t|
      t.string :name
      t.datetime :issue_date
      t.text :column_name
      t.text :data_info
      t.string :excel_name
      t.string :type_name

      t.timestamps
    end
  end

  def self.down
    drop_table :salary_infos
  end
end
