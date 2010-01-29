require 'iconv'  
require "spreadsheet"
class FilterController < ApplicationController
#  layout "menu"
    before_filter :configure_charsets  
  
  def configure_charsets  
    headers["Content-Type"]="text/html;charset=utf-8"  
  end    
  
  def index
    if params[:bonus]!=nil
      @bonus=SalaryInfo.new(params[:bonus])
      session[:bonus]=@bonus
    else
      @bonus=(session[:bonus]||=SalaryInfo.new)
    end
    @bonus.type_name='奖金'
     @dept_flag=true
     @bank_flag=true
     @role_arry=Role.find_by_id(session[:role_id])
     @user_arry=User.find_by_id(session[:user_id]) 
     @dept_array=Department.find_by_id(@user_arry.department_id) 
     role_name = @role_arry.role_name
       if role_name=='admin'|| role_name=='行长'
        @dept_flag=true
        @bank_flag=false
        @salary_arry=SalaryInfo.search(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.bank_check,'admin')
        @total_bon_arry=SalaryInfo.search_excel_info(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.bank_check,'admin')
       elsif role_name=='主任'
        @dept_flag=false
        @bank_flag=true 
        @salary_arry=SalaryInfo.search(@dept_array.dept_name,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.dept_check,'主任')
        @total_bon_arry=SalaryInfo.search_excel_info(@dept_array.dept_name,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.dept_check,'主任')
      else
        @salary_arry=SalaryInfo.search(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],0,'emp')
        @total_bon_arry=SalaryInfo.search_excel_info(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],0,'emp')  
      end 
      
      if @total_bon_arry!=nil&&@total_bon_arry.size>0
         @total_num=0
          @total_bon_arry.each { |tmp|
            data = tmp.data_info.split("|")
            if data[4]!=nil&&data[4]!=''
              @total_num=@total_num+data[4].to_i
            else
              @total_num=@total_num+data[3].to_i
            end
          }
      end
      
  end
  
  def historical_others_query
       if params[:bonus]!=nil
      @bonus=SalaryInfo.new(params[:bonus])
      session[:bonus]=@bonus
    else
      @bonus=(session[:bonus]||=SalaryInfo.new)
    end
    @bonus.type_name='其它'
     @dept_flag=true
     @bank_flag=true
     @role_arry=Role.find_by_id(session[:role_id])
     @user_arry=User.find_by_id(session[:user_id]) 
     @dept_array=Department.find_by_id(@user_arry.department_id) 
     role_name = @role_arry.role_name
       if role_name=='admin'|| role_name=='行长'
        @dept_flag=true
        @bank_flag=false
        @salary_arry=SalaryInfo.search(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.bank_check,'admin')
        @total_bon_arry=SalaryInfo.search(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.bank_check,'admin')
       elsif role_name=='主任'
        @dept_flag=false
        @bank_flag=true 
        @salary_arry=SalaryInfo.search(@dept_array.dept_name,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.dept_check,'主任')
        @total_bon_arry=SalaryInfo.search(@dept_array.dept_name,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.dept_check,'主任')
      else
        @salary_arry=SalaryInfo.search(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],0,'emp')
        @total_bon_arry=SalaryInfo.search(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],0,'emp')
    end

      if @total_bon_arry!=nil&&@total_bon_arry.size>0
         @total_num=0
          @total_bon_arry.each { |tmp|
            data = tmp.data_info.split("|")
            if data[4]!=nil&&data[4]!=''
              @total_num=@total_num+data[4].to_i
            else
              @total_num=@total_num+data[3].to_i
            end
          }
      end
        
  end
  
  def session_clear
    session[:bonus]=SalaryInfo.new
    redirect_to_index
  end
  
  def temp_bonus_query
    @temp_salary_arry=SalaryInfo.temp_bonus_search(session[:user_name],"奖金","2008-01-01",Time.now.strftime("%Y-%m-%d"),params[:page]);
#      @total_num=0
      @temp_salary_arry2= SalaryInfo.find(:all, :conditions => ['type_name=? AND name=? AND issue_date Between ? AND ?',"奖金",session[:user_name],"2008-01-01",Time.now.strftime("%Y-%m-%d")])
      if @temp_salary_arry2!=nil&&@temp_salary_arry2.size>0
         @total_num=0
          @temp_salary_arry2.each { |tmp|
            data = tmp.data_info.split("|")
            if data[4]!=nil&&data[4]!=''
              @total_num=@total_num+data[4].to_i
            else
              @total_num=@total_num+data[3].to_i
            end
          }
      end
  end
  
  def temp_others_query
    @temp_salary_arry=SalaryInfo.temp_bonus_search(session[:user_name],"其它","2008-01-01",Time.now.strftime("%Y-%m-%d"),params[:page]);
       @temp_salary_arry2= SalaryInfo.find(:all, :conditions => ['type_name=? AND name=? AND issue_date Between ? AND ?',"奖金",session[:user_name],"2008-01-01",Time.now.strftime("%Y-%m-%d")])
      if @temp_salary_arry2!=nil&&@temp_salary_arry2.size>0
         @total_num=0
          @temp_salary_arry2.each { |tmp|
            data = tmp.data_info.split("|")
            if data[4]!=nil&&data[4]!=''
              @total_num=@total_num+data[4].to_i
            else
              @total_num=@total_num+data[3].to_i
            end
          }
      end
  end
  
  def temp_generate_others_excel
      @bonus_arry=SalaryInfo.find(:all,:conditions => ['name=? AND type_name=? AND issue_date Between ? AND ?',session[:user_name],"其他","2008-01-01",Time.now.strftime("%Y-%m-%d")])
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new  
      sheet1 = book.create_worksheet
      sheet1.name = '表格1'
      str=""
      if @bonus_arry!=nil&&@bonus_arry.size>0
#        @headers = @bonus_arry.fetch(1).column_name.split("|")
#        k=0
#        @headers.each { |item|
#            sheet1[0,k]=item
#            k=k+1
#          }
        row=0
        @bonus_arry.each { |bon|
            col1=0
            col2=0
            bon.column_name.split("|").each{ |h|
               sheet1[row,col1]=h          
               col1=col1+1
            }
            bon.data_info.split("|").each{ |r|
              sheet1[row+1,col2]=r
              col2=col2+1
            }
            row=row+2
        }
      end
      #config excel style
#    format = Spreadsheet::Format.new :weight => :bold,  
#                                     :size => 13 
#    sheet1.row(0).default_format = format 
#    sheet1.row(0).height = 15  
    filename =Time.now.strftime("%Y_%m_%d") + '_temp_bonus'   
    book.write "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"  
    send_file "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"  
  end
  
  def temp_generate_bonus_excel
      @bonus_arry=SalaryInfo.find(:all,:conditions => ['name=? AND type_name=? AND issue_date Between ? AND ?',session[:user_name],"奖金","2008-01-01",Time.now.strftime("%Y-%m-%d")])
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new  
      sheet1 = book.create_worksheet
      sheet1.name = '表格1'
      str=""
      if @bonus_arry!=nil&&@bonus_arry.size>0
#        @headers = @bonus_arry.fetch(1).column_name.split("|")
#        k=0
#        @headers.each { |item|
#            sheet1[0,k]=item
#            k=k+1
#          }
        row=0
        @bonus_arry.each { |bon|
        col1=0
        col2=0
          bon.column_name.split("|").each{ |c|
               sheet1[row,col1]=c          
              col1=col1+1
          }
         bon.data_info.split("|").each{ |r|
              sheet1[row+1,col2]=r
              col2=col2+1
            }
            row=row+2
        }
      end
      #config excel style
#    format = Spreadsheet::Format.new :weight => :bold,  
#                                     :size => 13 
#    sheet1.row(0).default_format = format 
#    sheet1.row(0).height = 15  
    filename =Time.now.strftime("%Y_%m_%d") + '_temp_bonus'   
    book.write "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"  
    send_file "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"  
  end
  
#  def generate_csv
#    #######TODO 乱码
#    require 'faster_csv'
##     @salary_arry = SalaryInfo.find(:all,:conditions => ['name=? AND type_name=? AND issue_date Between ? AND ?',session[:user_name],session[:t_name],session[:start_date],session[:end_date]])
#     @salary_arry = SalaryInfo.find(:all,:conditions => ['type_name=? AND issue_date Between ? AND ?',session[:t_name],session[:start_date],session[:end_date]])
#     if @salary_arry!=nil&&@salary_arry.size>0
#        @headers = @salary_arry.fetch(1).column_name.split("|")
#        csv_string = FasterCSV.generate(:col_sep => "\t", :row_sep => "\r\n") do |csv|
#         @headers.each { |item|
##          con = Iconv.conv("utf-16le","utf-8",item.to_s)
##              puts con
#           csv << item
#        }
##         @salary_arry.each { |tmp|
##            tmp.data_info.split("|").each{ |r|
##              csv << r
##            }
##          }
#        end
#    end
#    Iconv.conv("GBK","utf-8",csv_string)
#    send_data(export_to_csv, :type => 'text/csv; charset=GBK; header=present', :filename => "bonus.csv")   
##      send_data csv_string,:type=>'text/csv; charset=utf-8 header=present', :disposition => "attachment; filename=bonus.csv"  
#end

  def generate_bonus_excel
      @bonus=session[:bonus]
       @bonus.type_name='奖金'
      @role_arry=Role.find_by_id(session[:role_id])
     @user_arry=User.find_by_id(session[:user_id]) 
     @dept_array=Department.find_by_id(@user_arry.department_id) 
     role_name = @role_arry.role_name
       if role_name=='admin'|| role_name=='行长'
        @bonus_arry=SalaryInfo.search_excel_info(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.bank_check,'admin')
       elsif role_name=='主任'
        @bonus_arry=SalaryInfo.search_excel_info(@dept_array.dept_name,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.dept_check,'主任')
      else
        @bonus_arry=SalaryInfo.search_excel_info(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],0,'emp')  
      end 
      
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new  
      sheet1 = book.create_worksheet
      sheet1.name = '表格1'
      str=""
      if @bonus_arry!=nil&&@bonus_arry.size>0
        @headers = @bonus_arry.fetch(1).column_name.split("|")
        k=0
        @headers.each { |item|
            sheet1[0,k]=item
            k=k+1
          }
        row=1
        @bonus_arry.each { |bon|
            col=0
            bon.data_info.split("|").each{ |r|
              sheet1[row,col]=r
              col=col+1
            }
            row=row+1
        }
      end
      #config excel style
    filename =Time.now.strftime("%Y_%m_%d") + '_bonus'   
    book.write "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"  
    send_file "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"  
  end
  
    def generate_others_excel
      @bonus=session[:bonus]
      @bonus.type_name='其它'
      @role_arry=Role.find_by_id(session[:role_id])
     @user_arry=User.find_by_id(session[:user_id]) 
     @dept_array=Department.find_by_id(@user_arry.department_id) 
     role_name = @role_arry.role_name
       if role_name=='admin'|| role_name=='行长'
        @bonus_arry=SalaryInfo.search_excel_info(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.bank_check,'admin')
       elsif role_name=='主任'
        @bonus_arry=SalaryInfo.search_excel_info(@dept_array.dept_name,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],@bonus.dept_check,'主任')
      else
        @bonus_arry=SalaryInfo.search_excel_info(0,session[:user_name],@bonus.type_name,@bonus.fDate,@bonus.eDate,params[:page],0,'emp')  
      end 
      
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new  
      sheet1 = book.create_worksheet
      sheet1.name = '表格1'
      str=""
      if @bonus_arry!=nil&&@bonus_arry.size>0
        @headers = @bonus_arry.fetch(1).column_name.split("|")
        k=0
        @headers.each { |item|
            sheet1[0,k]=item
            k=k+1
          }
        row=1
        @bonus_arry.each { |bon|
            col=0
            bon.data_info.split("|").each{ |r|
              sheet1[row,col]=r
              col=col+1
            }
            row=row+1
        }
      end
      #config excel style
    filename =Time.now.strftime("%Y_%m_%d") + '_bonus'   
    book.write "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"  
    send_file "#{RAILS_ROOT}/public/download_xls/#{filename}.xls"  
  end
  
  def show_bonus_detail
     if params[:id]==nil
       temp_sal_info_id=session[:temp_sal_info_id]
     else
       temp_sal_info_id=params[:id]
       session[:temp_sal_info_id]=params[:id]
   end
     @sal_detail = SalaryInfo.find(temp_sal_info_id)
     render :layout => 'modal' and return
  end
  
  def show_others_detail
     if params[:id]==nil
       temp_others_info_id=session[:temp_others_info_id]
     else
       temp_others_info_id=params[:id]
       session[:temp_others_info_id]=params[:id]
   end
     @others_detail = SalaryInfo.find(temp_others_info_id)
     render :layout => 'modal' and return
  end
  
  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
end
