class AddTypeNameToSalaries < ActiveRecord::Migration
  def self.up
    add_column :salaries, :type_name, :string
  end

  def self.down
    remove_column :salaries, :type_name
  end
end
