require 'iconv'    
class MigrationController < ApplicationController
  layout "menu"
  before_filter :configure_charsets  
#  @displayflag=false
  
  def configure_charsets  
    headers["Content-Type"]="text/html;charset=utf-8"  
  end    
  
  def index  
    @migration=Salary.new
   @fnameArry = fetchUploadedFile.paginate :per_page => 20, :page => params[:page]||1
   
#    if params[:id]!=nil
#      fname = params[:id]
#      @salary_arry=SalaryInfo.find_all_by_excel_name("#{fname}.csv")
#       if @salary_arry!=nil&&@salary_arry.size>0
#        @headers = @salary_arry.fetch(1).column_name.split("|")
#      end
#    end
    
  end
  
  def show 
    fname = params[:id]
    Iconv.conv("GBK","utf-8",fname)
     if fname==nil
       fname=session[:csv_name]
     else
       session[:csv_name]=fname
     end

    if fname.include? "(工资)"
#        @salaries=Salary.find_all_by_csv_name("#{fname}.csv")
        @salaries=Salary.search_by_csv_name(params[:page],"#{fname}.csv")
        @salary_arry=nil
      elsif
#      @salaries=nil
#      @salary_arry=SalaryInfo.find_all_by_excel_name("#{fname}.csv")
       @salary_arry=SalaryInfo.search_by_excel_name(params[:page],"#{fname}.csv")  
      if @salary_arry!=nil&&@salary_arry.size>0
          @headers = @salary_arry.fetch(1).column_name.split("|")
      end
    end   
    
    render :layout => 'modal' and return
  end
  
  def delete 
    fname = params[:id]
    Iconv.conv("GBK","utf-8",fname)
    if fname.include? "(工资)"
      Salary.delete_all(["csv_name=?","#{fname}.csv"])
    elsif
      SalaryInfo.delete_all(["excel_name=?","#{fname}.csv"])
  end
   File.delete(Iconv.conv("GBK","utf-8","#{RAILS_ROOT}/public/upload/#{fname}.csv"));
    redirect_to_index
  end
  
  def fetchUploadedFile
    fAry = Array.new
    Dir.foreach(Iconv.conv("GBK","utf-8","#{RAILS_ROOT}/public/upload")){ |file|
    ## updated by tim tang for ubuntu910
      fname= Iconv.conv("utf-8","utf-8",file)
      if fname.eql?(".")||fname.eql?("..")
        else
          fAry.push(fname)
      end
    }
    fAry
  end
  
  def uploadFile(file,type_name)  
    if !file.original_filename.empty?  
      @filename=getFileName(file.original_filename,type_name)   
      File.open(Iconv.conv("GBK","utf-8","#{RAILS_ROOT}/public/upload/#{@filename}"), "wb") do |f|  
        f.write(file.read)  
      end  
      return @filename  
    end  
  end  
  
  def getFileName(filename,type_name) 
    if !filename.nil? 
#      filename=Time.now.strftime("%Y_%m_%d") + '_' + filename  
      filename.insert(-5,"("+type_name+")")
    end  
  end  
  
  def save  
    unless request.get?  
      type_name=params[:type_name]
      if filename=uploadFile(params[:file]['file'],params[:type_name])  
        parseCSV(filename,type_name) 
      end  
    end  
  end  
  
  
  def parseCSV (filename,type_name)
    require 'faster_csv'
    rows = FasterCSV.parse(File.open(Iconv.conv("gb2312","utf-8","#{RAILS_ROOT}/public/upload/#{filename}")) {|f| f.read})
    if type_name=="工资"
        importCSV_sal(rows,filename,type_name)
      else
        importCSV_bonus(rows,filename,type_name)
    end
  
 end
 
 def importCSV_bonus (rows, filename,type_name)
   arry = Array.new
   column_name=""
   title=""
   i=0
   rows.each { |row|
   j=1
    data_info=""
      row.each { |cell| 
        if cell!=nil
          content=Iconv.conv("utf-8","GBK",cell.to_s)
          if i==0
            column_name << "#{content}|"
          else
            data_info << "#{content}|"
          end
          j=j+1
        end
      }
      arry.push(data_info.to_s)
      i=i+1
   }
   migrateCSV_bonus(arry, column_name, filename,type_name)   
 end
  
 def migrateCSV_bonus arry, column_name, filename, type_name
    arry.each do |data|
      @salaryInfo = SalaryInfo.new
      if data != nil && data.size > 0
        sdata = data.split "|"
        if sdata[2] != nil
          @salaryInfo.name = sdata[2]
          @u_arry=User.find(:all,:conditions=>['name=?',sdata[2]])
          if @u_arry!=nil&&@u_arry.size>0
             @salaryInfo.dept_name=@u_arry.fetch(0).department.dept_name
          end
          @salaryInfo.issue_date =sdata[0]
        end
#        if sdata[1] != nil
#          @salaryInfo.dept_name = sdata[1]
#        end
        @salaryInfo.data_info = data
        @salaryInfo.column_name = column_name
        @salaryInfo.excel_name = filename
#        issue_date=filename.split("_")
#        @salaryInfo.issue_date = issue_date[0]
        @salaryInfo.type_name = type_name
        @salaryInfo.save
      end
    end
    
    redirect_to_index
  end
  
   def importCSV_sal (rows, filename,type_name)
#    rows.delete_at(0)
   rows.each { |row|
     @sal=Salary.new
     @sal.issue_date=Iconv.conv("utf-8","GBK",row[1]) 
     user_name =Iconv.conv("utf-8","GBK",row[3])
      @u_arry=User.find(:all,:conditions=>['name=?',user_name])
          if @u_arry!=nil&&@u_arry.size>0
             @sal.dept_name=@u_arry.fetch(0).department.dept_name
          end
     @sal.name= Iconv.conv("utf-8","GBK",row[3])
#     @sal.dept_name=Iconv.conv("utf-8","GBK",row[2])   
     @sal.postion_num=Iconv.conv("utf-8","GBK",row[4])
     @sal.car_allowance=Iconv.conv("utf-8","GBK",row[5])
     @sal.housing_allowance=Iconv.conv("utf-8","GBK",row[6])
     @sal.reissue=Iconv.conv("utf-8","GBK",row[7])
     @sal.total_num=Iconv.conv("utf-8","GBK",row[8])
     @sal.lunion_fee=Iconv.conv("utf-8","GBK",row[9])
     @sal.housing_fund=Iconv.conv("utf-8","GBK",row[10])
     @sal.unemployment=Iconv.conv("utf-8","GBK",row[11])
     @sal.pension=Iconv.conv("utf-8","GBK",row[12])
     @sal.basic_medical=Iconv.conv("utf-8","GBK",row[13])
     @sal.trivial=Iconv.conv("utf-8","GBK",row[14])
     @sal.annunity=Iconv.conv("utf-8","GBK",row[15])
     @sal.tax_deduct=Iconv.conv("utf-8","GBK",row[16])
     @sal.re_deduct=Iconv.conv("utf-8","GBK",row[17])
     @sal.total_deduct=Iconv.conv("utf-8","GBK",row[18])
     @sal.final_num=Iconv.conv("utf-8","GBK",row[19])
     @sal.remark=Iconv.conv("utf-8","GBK",row[20])
     @sal.csv_name=filename
     @sal.type_name=type_name
     @sal.save
   }
    redirect_to_index
 end
 
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
   
  def sendemail
    SisMailer.deliver_sendmail 
    redirect_to_index
  end
  
#  judge str is utf-8 encode
  private
  def utf8? str
    begin
      utf8_arr = str.unpack('U*')
      true 
#      if utf8_arr && utf8_arr.size > 0
    rescue
      false
    end
  end

  
#  def parseExcel filename
#    require 'parseexcel'
#    puts "in parseExcel...."
#    #Open the excel file passed in from the commandline
#    workbook = Spreadsheet::ParseExcel.parse(Iconv.conv("gb2312","utf-8","#{RAILS_ROOT}/public/upload/#{filename}"))
#    
#    #Get the first worksheet
#    worksheet = workbook.worksheet(0)
#    
#    #cycle over every row
#    j=0
#    worksheet.each { |row|
#      i=0
#      if row != nil
#        #cycle over each cell in this row if it's not an empty row
#        row.each { |cell|
#          if cell != nil
#            contents = cell.to_s('utf-8')
#            puts "Row: #{j} Cell: #{i}> #{contents}"
#          end
#          i = i+1
#        }
#      end
#      j=j+1
#    }
#  end

#    def parseExcel filename   
#      require 'win32ole'
#      application = WIN32OLE.new('Excel.Application')
#      worksheet=application.Workbooks.Open("#{RAILS_ROOT}/public/upload/#{filename}").Worksheets(1)
#      worksheet.Activate  
#      contLoop = true 
#        while contLoop do      
#           colVal = worksheet.Cells(row, column).Value      
#           if (colVal) then      
#             # 如果这个字段非空，则表示这行有值     
#             # 在这里处理读取     
#             puts colVal
#           else      
#             # 这里表明结束。     
#             # End the loop      
#             contLoop = false      
#           end      
#           # go to the next Row      
#           row +=  1      
#       end   
#        application.Workbooks.Close
#  end

    
end
