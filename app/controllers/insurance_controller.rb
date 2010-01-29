class InsuranceController < ApplicationController
  
  def index
    if params[:sal]!=nil
      @sal=Salary.new(params[:sal])
    else
      @sal=Salary.new
    end
    @dept_flag=true
    @bank_flag=true
    @role_arry=Role.find_by_id(session[:role_id])
    @user_arry=User.find_by_id(session[:user_id]) 
    @dept_array=Department.find_by_id(@user_arry.department_id) 
    role_name = @role_arry.role_name
    if role_name=='admin'|| role_name=='行长'
      @dept_flag=true
      @bank_flag=false
      @insurace_arry = Salary.search_insurace(0,session[:user_name],@sal.fDate,@sal.eDate,params[:page],@sal.bank_check,'admin')
    elsif role_name=='主任'
      @dept_flag=false
      @bank_flag=true
      @insurace_arry = Salary.search_insurace(@dept_array.dept_name,session[:user_name],@sal.fDate,@sal.eDate,params[:page],@sal.dept_check,'主任')
    else
      @insurace_arry = Salary.search_insurace(0,session[:user_name],@sal.fDate,@sal.eDate,params[:page],0,'emp')
    end
#    @insurace_arry =Salary.search_insurace(session[:user_name],@sal.fDate,@sal.eDate,params[:page])
  end
  
  def temp_insurace_query
    @insurace_arry=Salary.temp_search_insurance(session[:user_name],"2008-01-01",Time.now.strftime("%Y-%m-%d"),params[:page])
    @insurace_arry_total=Salary.total_temp_insuarance(session[:user_name],"2008-01-01",Time.now.strftime("%Y-%m-%d"))
  end
  
  def temp_salary_query
    @salaries=Salary.temp_search_salary(session[:user_name],"2008-01-01",Time.now.strftime("%Y-%m-%d"),params[:page])
    @salaries_total =Salary.total_temp_salary(session[:user_name],"2008-01-01",Time.now.strftime("%Y-%m-%d"))
  end
  
  def temp_generate_insuarance_excel
      require "spreadsheet"
       @sal_arry = Salary.find(:all,:conditions => ['name=? AND issue_date Between ? AND ?',session[:user_name],"2008-01-01",Time.now.strftime("%Y-%m-%d")])
#      @sal_arry = Salary.find(:all,:conditions => ['issue_date Between ? AND ?',"2008-01-01",Time.now.strftime("%Y-%m-%d")])
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new  
      sheet1 = book.create_worksheet
      sheet1.name = '表格1'
      sheet1.row(0).concat %w{序号  日期  部门  姓名  公积金 失业金 养老保险  医疗保险  }
      if @sal_arry!=nil&&@sal_arry.size>0
        row=1
        @sal_arry.each { |sal|
               sheet1[row,0]=row
               sheet1[row,1]=sal.issue_date.strftime("%Y-%m-%d")
               sheet1[row,3]=sal.name
               sheet1[row,2]=sal.dept_name
               sheet1[row,4]=sal.housing_fund
               sheet1[row,5]=sal.unemployment
               sheet1[row,6]=sal.pension
               sheet1[row,7]=sal.basic_medical
              row=row+1  
            }
      end
      #config excel style
#    format = Spreadsheet::Format.new :weight => :bold,  
#                                     :size => 13 
#    sheet1.row(0).default_format = format 
#    sheet1.row(0).height = 15  
    filename =Time.now.strftime("%Y_%m_%d") + '_temp_insurance'   
    book.write "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"  
    send_file "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"   
    
  end
  
  def temp_generate_sal_excel
       @sal_arry = Salary.find(:all,:conditions => ['issue_date Between ? AND ?',"2008-01-01",Time.now.strftime("%Y-%m-%d")])
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new  
      sheet1 = book.create_worksheet
      sheet1.name = '表格1'
      sheet1.row(0).concat %w{序号  日期  部门  姓名  岗位工资  车贴  住房补贴  补发  应发金额  工会费 公积金 失业金 养老保险  医疗保险  共济金 企业年金  扣税  补扣  扣项合计  实发金额  备注}
      if @sal_arry!=nil&&@sal_arry.size>0
        row=1
        @sal_arry.each { |sal|
               sheet1[row,0]=row
               sheet1[row,1]=sal.issue_date.strftime("%Y-%m-%d")
               sheet1[row,3]=sal.name
               sheet1[row,2]=sal.dept_name
               sheet1[row,4]=sal.postion_num
               sheet1[row,5]=sal.car_allowance
               sheet1[row,6]=sal.housing_allowance
               sheet1[row,7]=sal.reissue
               sheet1[row,8]=sal.total_num
               sheet1[row,9]=sal.lunion_fee
               sheet1[row,10]=sal.housing_fund
               sheet1[row,11]=sal.unemployment
               sheet1[row,12]=sal.pension
               sheet1[row,13]=sal.basic_medical
               sheet1[row,14]=sal.trivial
               sheet1[row,15]=sal.annunity
               sheet1[row,16]=sal.tax_deduct
               sheet1[row,17]=sal.re_deduct
               sheet1[row,18]=sal.total_deduct
               sheet1[row,19]=sal.final_num
               sheet1[row,20]=sal.remark
              row=row+1  
            }
      end
      #config excel style
    format = Spreadsheet::Format.new :weight => :bold,  
                                     :size => 13 
    sheet1.row(0).default_format = format 
    sheet1.row(0).height = 15  
    filename =Time.now.strftime("%Y_%m_%d") + '_salary'   
    book.write "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"  
    send_file "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"      
  end
  
end
