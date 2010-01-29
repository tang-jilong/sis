class SalaryInfo < ActiveRecord::Base
  require 'will_paginate'
    attr_accessor :sal_name
    attr_accessor :t_salary
    attr_accessor :t_num 
    attr_accessor :t_bonus
    attr_accessor :t_others
    attr_accessor :total
    attr_accessor :fDate
    attr_accessor :eDate
    attr_accessor :dept_check
    attr_accessor :bank_check
    
  SALARY_TYPE = [
  ["奖金","奖金"],
  ["工资","工资"],
#  ["过节费","过节费"],
  ["其它","其它"]
  ]
  
#  validates_inclusion_of :type_name, :in => SalaryInfo::SALARY_TYPE.map{|salt_name,id| id}
  
  def self.search(dept_name,user_name,type_name,start_date, end_date,page,range,role)
    con_str=''
      if role=='admin'
      if range=='1'
          con_str=['type_name=? AND issue_date Between ? AND ?',type_name,start_date,end_date]
        else
          con_str=['type_name=? AND name=? AND issue_date Between ? AND ?',type_name,user_name,start_date,end_date]
      end
    elsif role=='主任'
      if range =='1'
        con_str=['type_name=? AND dept_name=? AND issue_date Between ? AND ?',type_name,dept_name,start_date,end_date]
      else
        con_str=['type_name=? AND name=? AND issue_date Between ? AND ?',type_name,user_name,start_date,end_date]
      end
    else
      con_str=['type_name=? AND name=? AND issue_date Between ? AND ?',type_name,user_name,start_date,end_date]
    end
      
    if type_name!=nil&&start_date!=nil
      paginate :per_page => 10, :page => page||1,  
               :conditions => con_str,  
               :order => 'id'  
    end
  end
  
    
  def self.search_excel_info(dept_name,user_name,type_name,start_date, end_date,page,range,role)
    con_str=''
      if role=='admin'
      if range=='1'
          con_str=['type_name=? AND issue_date Between ? AND ?',type_name,start_date,end_date]
        else
          con_str=['type_name=? AND name=? AND issue_date Between ? AND ?',type_name,user_name,start_date,end_date]
      end
    elsif role=='主任'
      if range =='1'
        con_str=['type_name=? AND dept_name=? AND issue_date Between ? AND ?',type_name,dept_name,start_date,end_date]
      else
        con_str=['type_name=? AND name=? AND issue_date Between ? AND ?',type_name,user_name,start_date,end_date]
      end
    else
      con_str=['type_name=? AND name=? AND issue_date Between ? AND ?',type_name,user_name,start_date,end_date]
    end
      
    if type_name!=nil&&start_date!=nil
        SalaryInfo.find(:all,:conditions=>con_str)
    end
  end

  def self.temp_bonus_search(user_name,type_name,start_date, end_date,page)
    con_str=['type_name=? AND name=? AND issue_date Between ? AND ?',type_name,user_name,start_date,end_date]
#     con_str=['type_name=? AND issue_date Between ? AND ?',type_name,start_date,end_date]
    if type_name!=nil&&start_date!=nil
      paginate :per_page => 10, :page => page||1,  
               :conditions => con_str,  
               :order => 'id'  
    end
    
  end
 

 def self.search_by_excel_name (page ,fname)
    paginate :per_page => 20, :page => page||1,  
                :conditions => ['excel_name=?',fname],  
                :order => 'id'  
 end
  
end
