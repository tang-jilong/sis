require 'digest/sha1'
class User < ActiveRecord::Base
  belongs_to :role
  belongs_to :department
  belongs_to :salary_level
  
  attr_accessor :fDate
  attr_accessor :eDate
  
  SALARY_POINT = [
  ["1","1"],
  ["1.5","1.5"],
  ["2","2"],
  ["2.5","2.5"],
  ["3","3"],
  ["3.5","3.5"],
  ["4","4"],
  ["4.5","4.5"],
  ["5","5"],
  ["5.5","5.5"],
  ["6","6"],
  ["6.5","6.5"],
  ["7","7"],
  ["7.5","7.5"],
  ["8","8"],
  ["8.5","8.5"],
  ["9","9"],
  ["9.5","9.5"],
  ["10","10"],
  ["10.5","10.5"],
  ["11","11"]
  ]
  
  GRADE_ASSESS_LEVEL = [
  ["A","A"],
  ["A+","A+"],
  ["B","B"],
  ["B+","B+"],
  ["C","C"],
  ["D","D"]
  ]
  
  
  validates_presence_of :name
  validates_presence_of :birthday
  validates_uniqueness_of :name
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  validate :password_non_blank
  validates_format_of :email, :with=>/^[a-zA-Z0-9_\.]+@[a-zA-Z0-9-]+[\.a-zA-Z]+$/
  validates_inclusion_of :role_id,:in => Role.find_roles.map{|role_name,id| id}
  validates_inclusion_of :department_id,:in => Department.find_depts.map{|dept_name,id| id}
  validates_inclusion_of :salary_level_id,:in => SalaryLevel.find_level.map{|dept_name,id| id}
  validates_inclusion_of :salary_point,:in => User::SALARY_POINT.map{|sp_name,id| id}
  validates_inclusion_of :grade_assess_level,:in => User::GRADE_ASSESS_LEVEL.map{|gal_name,id| id}
  validates_presence_of :hr_id
  validates_presence_of :work_id
  
  
    def self.find_users(page)  
      require 'will_paginate'   
        paginate :per_page => 20, 
                 :page => page||1,
                 :order => 'id'    
  end  
  
  
  def self.authenticate(name, password)
    user = self.find_by_name(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end
  
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def after_destroy
    if User.count.zero?
      raise "Can't delete last user"
    end
  end
  
  
  private
  def password_non_blank
    errors.add(:password, "Missing password" ) if hashed_password.blank?
  end
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end
