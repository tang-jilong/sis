class Salary < ActiveRecord::Base
  require 'will_paginate'
  attr_accessor :fDate
  attr_accessor :eDate
  attr_accessor :dept_check
  attr_accessor :bank_check
  
  
  
  
  def self.search_insurace(dept_name,user_name,start_date, end_date,page,range,role)  
    con_str=""
    if role=='admin'
      if range=='1'
          con_str=['issue_date Between ? AND ?',start_date,end_date]
        else
          con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
      end
    elsif role=='主任'
      if range =='1'
        con_str=['dept_name=? AND issue_date Between ? AND ?',dept_name,start_date,end_date]
      else
        con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
      end
    else
      con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
    end
        
    paginate :per_page => 10, 
             :page => page||1,  
               :conditions => con_str,
             :order => 'id'  
  end  
  
  def self.search_excel_info(dept_name,user_name,start_date, end_date,page,range,role)
      con_str=""
    if role=='admin'
      if range=='1'
          con_str=['issue_date Between ? AND ?',start_date,end_date]
        else
          con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
      end
    elsif role=='主任'
      if range =='1'
        con_str=['dept_name=? AND issue_date Between ? AND ?',dept_name,start_date,end_date]
      else
        con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
      end
    else
      con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
    end

        Salary.find(:all, :conditions=>con_str)
  end
  
  def self.search_total_search(dept_name,user_name,start_date, end_date,page,range,role)
       con_str=""
    if role=='admin'
      if range=='1'
          con_str=['issue_date Between ? AND ?',start_date,end_date]
        else
          con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
      end
    elsif role=='主任'
      if range =='1'
        con_str=['dept_name=? AND issue_date Between ? AND ?',dept_name,start_date,end_date]
      else
        con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
      end
    else
      con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
    end
     Salary.find(:all, :select=>['sum(postion_num) as postion_num,sum(car_allowance) as car_allowance,sum(housing_allowance) as housing_allowance,sum(reissue) as reissue,sum(total_num) as total_num,sum(lunion_fee) as lunion_fee,sum(housing_fund) as housing_fund,sum(unemployment) as unemployment,sum(pension) as pension,sum(basic_medical) as basic_medical,sum(trivial) as trivial,sum(annunity) as annunity,sum(tax_deduct) as tax_deduct,sum(re_deduct) as re_deduct,sum(total_deduct) as total_deduct,sum(final_num) as final_num'],:conditions=>['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date])
  end
  
  
  def self.temp_search_insurance(user_name,start_date, end_date,page)
    con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
#    con_str=['issue_date Between ? AND ?',start_date,end_date]
    paginate :per_page => 10, 
         :page => page||1,  
           :conditions => con_str,
         :order => 'id'  
  end
  
  def self.total_temp_insuarance(user_name,start_date, end_date)
    Salary.find(:all, :select=>['sum(housing_fund) as housing_fund,sum(unemployment) as unemployment,sum(pension) as pension,sum(basic_medical) as basic_medical'],:conditions=>['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date])
  end
  
  def self.temp_search_salary(user_name,start_date, end_date,page)
        con_str=['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date]
#    con_str=['issue_date Between ? AND ?',start_date,end_date]
    paginate :per_page => 10, 
         :page => page||1,  
           :conditions => con_str,
         :order => 'id'  
  end
  
   def self.total_temp_salary(user_name,start_date, end_date)
    Salary.find(:all, :select=>['sum(postion_num) as postion_num,sum(car_allowance) as car_allowance,sum(housing_allowance) as housing_allowance,sum(reissue) as reissue,sum(total_num) as total_num,sum(lunion_fee) as lunion_fee,sum(housing_fund) as housing_fund,sum(unemployment) as unemployment,sum(pension) as pension,sum(basic_medical) as basic_medical,sum(trivial) as trivial,sum(annunity) as annunity,sum(tax_deduct) as tax_deduct,sum(re_deduct) as re_deduct,sum(total_deduct) as total_deduct,sum(final_num) as final_num'],:conditions=>['name=? AND issue_date Between ? AND ?',user_name,start_date,end_date])
  end
  
  def self.search_by_csv_name page,filename
    paginate :per_page => 20, 
             :page => page||1,  
             :conditions => ['csv_name=?',filename],
             :order => 'id'  
  end
  
  def self.search_dept_summary (start_date, end_date,page)
#    @salaries = Salary.find(:all,
       paginate :per_page => 10, 
                :page => page||1,  
                :select=>"dept_name,count(0) as num, sum(postion_num) as postion_num,sum(car_allowance) as car_allowance,sum(housing_allowance) as housing_allowance,sum(reissue) as reissue,sum(total_num) as total_num,sum(lunion_fee) as lunion_fee,sum(housing_fund) as housing_fund,sum(unemployment) as unemployment,sum(pension) as pension,sum(basic_medical) as basic_medical,sum(trivial) as trivial,sum(annunity) as annunity,sum(tax_deduct) as tax_deduct,sum(re_deduct) as re_deduct,sum(total_deduct) as total_deduct,sum(final_num) as final_num",
                :conditions=> ['issue_date Between ? AND ?',start_date,end_date],
                :group => "dept_name",
                :order => 'id'
#    )
    #     issue_date,  dept_name, postion_num, car_allowance, housing_allowance, reissue, total_num, lunion_fee, housing_fund, unemployment, pension, basic_medical, trivial, annunity, tax_deduct, re_deduct, total_deduct, final_num, remark, created_at, updated_at, csv_name, type_name
    #    paginate :per_page => 20, 
    #             :page => page||1,  
    #             :conditions => ['issue_date Between ? AND ?',start_date,end_date],
    #             :order => 'id'  
  end
  
  def self.search_all_dept_summary (start_date, end_date)
     @salaries = Salary.find(:all,
            :select=>"dept_name,count(0) as num, sum(postion_num) as postion_num,sum(car_allowance) as car_allowance,sum(housing_allowance) as housing_allowance,sum(reissue) as reissue,sum(total_num) as total_num,sum(lunion_fee) as lunion_fee,sum(housing_fund) as housing_fund,sum(unemployment) as unemployment,sum(pension) as pension,sum(basic_medical) as basic_medical,sum(trivial) as trivial,sum(annunity) as annunity,sum(tax_deduct) as tax_deduct,sum(re_deduct) as re_deduct,sum(total_deduct) as total_deduct,sum(final_num) as final_num",
            :conditions=> ['issue_date Between ? AND ?',start_date,end_date],
            :group => "dept_name",
            :order => 'id'
     )
  end
end
