class SalaryLevel < ActiveRecord::Base
   has_many :users,
            :dependent => :destroy
            
            
   validates_presence_of :name
   validates_uniqueness_of :name
   
    def self.find_level
    SalaryLevel.find(:all, :order => 'name').collect { |item| [item.name, item.id] }
  end   
  
  def self.find_all_level page
     require 'will_paginate'
     paginate :per_page => 10, 
             :page => page||1,  
             :order => 'id'  
    
  end
end
