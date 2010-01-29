class RolesController < ApplicationController
  layout "menu"
  
  # GET /roles
  # GET /roles.xml
  def index
    @roles = Role.find_all_roles params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = Role.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])
    respond_to do |format|
      if @role.save
        flash[:notice] = "Role #{@role.role_name} was successfully created."
        format.html { redirect_to_index}
        format.xml  { render :xml => @role, :status => :created, :location => @role }
      else
         @roles = Role.find_all_roles params[:page]
        format.html { render :action => "index" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])
    
    respond_to do |format|
      if @role.update_attributes(params[:role])
        flash[:notice] = "Role #{@role.role_name} was successfully updated."
        format.html { redirect_to_index}
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
#  def destroy
#    @role = Role.find(params[:id])
#    @role.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(roles_url) }
#      format.xml  { head :ok }
#    end
#  end
  
  def delete 
     @role = Role.find(params[:id])
     begin
      @role.destroy
      flash[:notice] = "Role #{@role.role_name} was deleted"
     rescue Exception => e
       flash[:notice] = e.message
     end
    respond_to do |format|
      format.html { redirect_to(roles_url) }
      format.xml  { head :ok }
    end 
  end
  
  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
end
