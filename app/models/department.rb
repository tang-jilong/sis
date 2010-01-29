class Department < ActiveRecord::Base
  has_many :users,
           :dependent => :destroy
    
    
    validates_presence_of :dept_name
    validates_uniqueness_of :dept_name
    
   def self.find_depts
    Department.find(:all, :order => 'dept_name').collect { |item| [item.dept_name, item.id] }
  end  
  
  
  def self.find_all_depts page
    require 'will_paginate'
    paginate :per_page => 10,
             :page => page||1,  
             :order => 'id'
  end
end
