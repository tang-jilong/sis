class CreateSalaries < ActiveRecord::Migration
  def self.up
    create_table :salaries do |t|
      t.datetime :issue_date
      t.string :name
      t.string :dept_name
      t.string :postion_num
      t.string :car_allowance
      t.string :housing_allowance
      t.string :reissue
      t.string :total_num
      t.string :lunion_fee
      t.string :housing_fund
      t.string :unemployment
      t.string :pension
      t.string :basic_medical
      t.string :trivial
      t.string :annunity
      t.string :tax_deduct
      t.string :re_deduct
      t.string :total_deduct
      t.string :final_num
      t.text :remark

      t.timestamps
    end
  end

  def self.down
    drop_table :salaries
  end
end
