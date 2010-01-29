class AddCsvNameToSalaries < ActiveRecord::Migration
  def self.up
    add_column :salaries, :csv_name, :string
  end

  def self.down
    remove_column :salaries, :csv_name
  end
end
