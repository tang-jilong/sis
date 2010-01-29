class UsersController < ApplicationController
#  before_filter :find_menu_info
  layout "menu"
  
   def find_menu_info 
    @menu = (session[:menu] ||= Menu.new)
  end
  
  
  # GET /users
  # GET /users.xml
  def index

    getsUserBasicInfo(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  def getsUserBasicInfo page
    @users = User.find_users(page)
    @menu = session[:menu]
    @roleItmes = Role.find_roles
    @deptItems = Department.find_depts
    @sal_lItems = SalaryLevel.find_level
  end
#  private :getsUserBasicInfo
  

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
   
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @roleItmes=Role.find_roles
    @deptItems=Department.find_depts
    @birthday=@user.birthday
    @sal_lItems=SalaryLevel.find_level
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.birthday=params[:birthday]
    
    respond_to do |format|
      if @user.save
        flash[:notice] = "User #{@user.name} was successfully created."
        format.html { redirect_to(:action=>'index' ) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        getsUserBasicInfo params[:page]
        format.html { render :action => "index" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
    
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    @user.birthday=params[:birthday]
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.name} was successfully updated."
        format.html { redirect_to_index }
        format.xml  { head :ok }
      else
        getsUserBasicInfo params[:page]
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
 

  # DELETE /users/1
  # DELETE /users/1.xml
  def delete
    @user = User.find(params[:id])
    begin
      flash[:notice] = "User #{@user.name} was deleted"
      @user.destroy
    rescue Exception => e
      flash[:notice] = e.message
    end
    respond_to do |format|
      format.html { redirect_to_index }
      format.xml  { head :ok }
    end
  end
  

  
  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
end
