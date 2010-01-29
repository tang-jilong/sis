class MenuController < ApplicationController
  
  def index
    @menu = (session[:menu] ||= Menu.new)
    role=Role.find_by_id(session[:role_id])
    @menu.find_top_menu role
    session[:menu]=@menu
    @bulletins = Bulletin.find_all_bulletins params[:page]
  
#    redirect_to(:controller=>"bulletins", :action=>"index")
  end
  
  def show
      if params[:id]==nil
       bulletin_id=session[:bulletin_id]
     else
       bulletin_id=params[:id]
       session[:bulletin_id]=params[:id]
   end
    @bulletin = Bulletin.find(bulletin_id)
     render :layout => 'modal' and return
  end
  
  
  def find_side_menu 
    @menu = (session[:menu] ||= Menu.new)
    role=Role.find_by_id(session[:role_id])
    @menu.find_sub_menu params[:id],role
#    print @menu.sidemenu.size 
    
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
  end
  
#  def menu_auth item
#      if item.role_name == "admin"
#        puts "in admin ";
#       @topmenu= Menu.find(:all,:conditions=>['parent_id=0']);
#     else item.role_name == "员工"
#       puts "in employee";
#       @topmenu= Menu.find(:all,:conditions=>['parent_id=? and role_name=?',0,'员工'])
#      end
#     @menu.topmenu=@topmenu
#  end
  
   def user_info_edit
    @user = User.find_by_id(session[:user_id])
    @roleItmes=Role.find_roles
    @deptItems=Department.find_depts
    @birthday=@user.birthday
  end

  def update_user
    if params[:user]!=nil
      @temp =User.new(params[:user])
    end
    arry = User.find(:all,:conditions=>['name=?', @temp.name])
    @user = arry.fetch(0)
    @user.birthday=params[:birthday]
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.name} was successfully updated."
        format.html {  redirect_to_index }
        format.xml  { head :ok }
    else
#      user_info_edit
        format.html { render :action => "user_info_edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
  
end
