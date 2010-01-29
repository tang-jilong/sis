class DepartmentsController < ApplicationController
  layout "menu"
  # GET /departments
  # GET /departments.xml
  def index
    @departments = Department.find_all_depts params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @departments }
    end
  end

  # GET /departments/1
  # GET /departments/1.xml
  def show
    @department = Department.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @department }
    end
  end

  # GET /departments/new
  # GET /departments/new.xml
  def new
    @department = Department.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @department }
    end
  end

  # GET /departments/1/edit
  def edit
    @department = Department.find(params[:id])
  end

  # POST /departments
  # POST /departments.xml
  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save
        flash[:notice] = "Department #{@department.dept_name} was successfully created."
        format.html { redirect_to_index }
        format.xml  { render :xml => @department, :status => :created, :location => @department }
      else
        @departments = Department.find_all_depts params[:page]
        format.html { render :action => "index" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /departments/1
  # PUT /departments/1.xml
  def update
    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.update_attributes(params[:department])
        flash[:notice] = "Department #{@department.dept_name} was successfully updated."
        format.html { redirect_to_index }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.xml
  def delete
    @department = Department.find(params[:id])
     begin
      @department.destroy
      flash[:notice] = "Department #{@department.dept_name} was deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end
      respond_to do |format|
        format.html { redirect_to(departments_url) }
        format.xml  { head :ok }
      end
 
  end
  
   private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
end
