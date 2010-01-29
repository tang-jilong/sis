class ComparatorController < ApplicationController
  
  def index
      @users=User.find_users params[:page]
      @cuser_arry = (session[:@cuser_arry] ||= Array.new)
  end
  
  def add_to_comparator_ajax
    if params[:user]!=nil
      @user =User.new(params[:user])
    else
      @user=User.new
    end
    
    name_str=""
    sql=""
    @cuser_arry=session[:@cuser_arry]
    if @cuser_arry.size>0
       @cuser_arry.each { |us|
          name_str =name_str +"'"+ us.name + "',"
        }
         nstr=name_str.slice(0,name_str.length-1)
         sql ="SELECT name as name,data_info as data_info,type_name as type_name FROM `salary_infos` WHERE (issue_date >= '"+@user.fDate+"' AND issue_date <= '"+@user.eDate+"' AND name in ("+nstr+"))"
         sql2="SELECT name as uname,sum(total_num) as tnum,sum(final_num) as fnum FROM `salaries` WHERE issue_date >= '"+@user.fDate+"' AND issue_date <= '"+@user.eDate+"' AND name in ("+nstr+") group by name"
      else
        sql="SELECT name as name,data_info as data_info,type_name as type_name FROM `salary_infos` WHERE (issue_date >= '"+@user.fDate+"' AND issue_date <= '"+@user.eDate+"')"
        sql2="SELECT name as uname,,sum(total_num) as tnum,sum(final_num) as fnum FROM `salaries` WHERE issue_date >= '"+@user.fDate+"' AND issue_date <= '"+@user.eDate+"' group by name"
    end
    
   @salary_arry=Salary.find_by_sql(sql2.to_s)
    @bouns_arry = SalaryInfo.find_by_sql(sql.to_s)
    @comparable_arry=Array.new
    @cuser_arry.each { |item|
    @user_temp = User.find(item)
     com=SalaryInfo.new
      com.t_others=0
      com.t_salary=0
      com.t_bonus=0
      com.t_num=0
     @bouns_arry.each { |bon|
        if @user_temp.name==bon.name
          com.sal_name=bon.name
          item=bon.data_info.split("|")
             if bon.type_name=="奖金"
                if item[4]!=nil&&item[4]!=''
                  com.t_bonus=com.t_salary+item[4].to_i
                else
                  com.t_bonus=com.t_salary+item[3].to_i
                end
           elsif bon.type_name=="其它"
                 if item[4]!=nil&&item[4]!=''
                  com.t_others=com.t_others+item[4].to_i
                else
                  com.t_others=com.t_others+item[3].to_i
                end
          end
        end
     }
     @salary_arry.each { |sal|
        if sal.uname== @user_temp.name
          com.t_salary=sal.fnum.to_i
          com.t_num=sal.tnum.to_i
        end
     }
     com.fDate=@user.fDate
     com.eDate=@user.eDate
     puts com.t_num
     puts com.t_others
     puts com.t_bonus
     com.total=com.t_num+com.t_others+com.t_bonus
      @comparable_arry.push(com)
    }
    
#    render :layout => 'modal' and return
    render :layout => 'menu'
    #    render :layout => false 
  end
  
  def add_cuser
    @cuser_arry = (session[:@cuser_arry] ||= Array.new)
    @user = User.find(params[:id])
    @cuser_arry.push(@user)
    session[:@cuser_arry]=@cuser_arry
    render :partial =>"add_cuser" and return 
  end
  
  def delete_cuser
     @user = User.find(params[:id])
    @cuser_arry = session[:@cuser_arry]
    @cuser_arry.delete(@user)
     render :partial =>"add_cuser" and return 
  end
  
  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
  
#    def user_layout
#     if current_user.admin?
#       "modal"
#     else
#       "menu"
#     end
#   end 
end
