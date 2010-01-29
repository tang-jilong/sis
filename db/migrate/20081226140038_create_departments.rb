class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string :dept_name
      t.text :remark

      t.timestamps
    end
  end

  def self.down
    drop_table :departments
  end
end
