# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090106053711) do

  create_table "bulletins", :force => true do |t|
    t.string   "title"
    t.datetime "issue_date"
    t.text     "content"
    t.string   "autor"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.string   "dept_name"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.string   "flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role_name"
    t.string   "action"
  end

  create_table "roles", :force => true do |t|
    t.string   "role_name"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "salaries", :force => true do |t|
    t.datetime "issue_date"
    t.string   "name"
    t.string   "dept_name"
    t.string   "postion_num"
    t.string   "car_allowance"
    t.string   "housing_allowance"
    t.string   "reissue"
    t.string   "total_num"
    t.string   "lunion_fee"
    t.string   "housing_fund"
    t.string   "unemployment"
    t.string   "pension"
    t.string   "basic_medical"
    t.string   "trivial"
    t.string   "annunity"
    t.string   "tax_deduct"
    t.string   "re_deduct"
    t.string   "total_deduct"
    t.string   "final_num"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "csv_name"
    t.string   "type_name"
  end

  create_table "salary_infos", :force => true do |t|
    t.string   "name"
    t.datetime "issue_date"
    t.text     "column_name"
    t.text     "data_info"
    t.string   "excel_name"
    t.string   "type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dept_name"
  end

  create_table "salary_levels", :force => true do |t|
    t.string   "name"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "birthday"
    t.integer  "role_id"
    t.integer  "department_id"
    t.string   "hr_id"
    t.string   "work_id"
    t.string   "salary_point"
    t.string   "grade_assess_level"
    t.text     "remark"
    t.string   "email"
    t.integer  "salary_level_id"
  end

end
