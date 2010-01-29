class LoginController < ApplicationController
  layout "menu"
  
  def login
    if request.post?
      @user = User.authenticate(params[:name], params[:password])
      
      if @user
        session[:user_id] = @user.id
        session[:user_name] = @user.name
        session[:role_id] = @user.role_id
        session[:hr_id] = @user.hr_id
        session[:work_id] = @user.work_id
        session[:salary_point]=@user.salary_point
        session[:grade_assess_level]=@user.grade_assess_level
        redirect_to(:action => "index")
      else
        flash.now[:login_notice] = "application.login_msg.login_error"
#        sendemail
      end
    end
  end
 
 def sendemail
    SisMailer.deliver_sendmail 
    redirect_to_index
  end
  
  def logout
    session[:user_id] = nil
    flash[:login_notice] = "login.login.logout_msg"
    redirect_to(:action => "login")
  end
  
  
  
  def index
    redirect_to :controller => 'menu', :action => 'index'
  end
  
end
