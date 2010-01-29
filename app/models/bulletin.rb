class Bulletin < ActiveRecord::Base
  
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :issue_date
  validates_presence_of :content
  
  def self.find_all_bulletins page
     require 'will_paginate'
    paginate :per_page => 10, 
             :page => page||1,  
             :order => 'id DESC'
  end
  
end
