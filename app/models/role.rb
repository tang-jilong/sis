class Role < ActiveRecord::Base
  has_many :users,
           :dependent => :destroy
  
  
   validates_presence_of :role_name
    validates_uniqueness_of :role_name
    
  def self.find_roles
    Role.find(:all, :order => 'role_name').collect { |item| [item.role_name, item.id] }
  end   
  
  def self.find_all_roles page
     require 'will_paginate'
    paginate :per_page => 10, 
             :page => page||1,  
             :order => 'id'  
  end
end
