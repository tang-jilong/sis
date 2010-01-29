class SalariesController < ApplicationController
  layout "menu"

  
  # GET /salaries
  # GET /salaries.xml
  def index
      @salary=(session[:salary]||=Salary.new);
      @dept_flag=true
      @bank_flag=true
      @role_arry=Role.find_by_id(session[:role_id])
      @user_arry=User.find_by_id(session[:user_id]) 
      @dept_array=Department.find_by_id(@user_arry.department_id) 
      role_name = @role_arry.role_name

      if role_name=='admin'|| role_name=='行长'
        @dept_flag=true
        @bank_flag=false
        @salaries = Salary.search_insurace(0,session[:user_name],@salary.fDate,@salary.eDate,params[:page],@salary.bank_check,'admin')
        @salaries_total = Salary.search_total_search(0,session[:user_name],@salary.fDate,@salary.eDate,params[:page],@salary.bank_check,'admin')
      elsif role_name=='主任'
        @dept_flag=false
        @bank_flag=true
        @salaries = Salary.search_insurace(@dept_array.dept_name,session[:user_name],@salary.fDate,@salary.eDate,params[:page],@salary.dept_check,'主任')
        @salaries_total = Salary.search_total_search(@dept_array.dept_name,session[:user_name],@salary.fDate,@salary.eDate,params[:page],@salary.dept_check,'主任')
      else
        @salaries = Salary.search_insurace(0,session[:user_name],@salary.fDate,@salary.eDate,params[:page],0,'emp')
        @salaries_total = Salary.search_total_search(0,session[:user_name],@salary.fDate,@salary.eDate,params[:page],0,'emp')
    end
  end
  
  def search_salary
     if params[:salary]!=nil
      @salary=Salary.new(params[:salary])
      session[:salary]=@salary
    else
       @salary=(session[:salary]||=Salary.new)
   end
   redirect_to_index
 end
 
   def session_clear
    session[:salary]=Salary.new
    redirect_to_index
  end
  
  
  def export_to_excel
    require "spreadsheet"
      @salary=session[:salary];
      @role_arry=Role.find_by_id(session[:role_id])
      @user_arry=User.find_by_id(session[:user_id]) 
      @dept_array=Department.find_by_id(@user_arry.department_id) 
      role_name = @role_arry.role_name
      if role_name=='admin'|| role_name=='行长'
        @sal_arry = Salary.search_excel_info(0,session[:user_name],@salary.fDate,@salary.eDate,params[:page],@salary.bank_check,'admin')
      elsif role_name=='主任'
        @sal_arry = Salary.search_excel_info(@dept_array.dept_name,session[:user_name],@salary.fDate,@salary.eDate,params[:page],@salary.dept_check,'主任')
      else
        @sal_arry = Salary.search_excel_info(0,session[:user_name],@salary.fDate,@salary.eDate,params[:page],0,'emp')
      end
      
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
  
  def show
    export_to_excel
  end
  
  def create
     if params[:fDate]!=nil
      start_date = params[:fDate]
    else
      start_date = session[:start_date]
    end
    if params[:eDate]!=nil
      end_date = params[:eDate]
    else
      end_date = session[:end_date]
    end
    session[:start_date]=start_date
    session[:end_date]=end_date
    redirect_to_index
  end  
  
  private 
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
  
end
