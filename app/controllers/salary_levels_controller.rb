class SalaryLevelsController < ApplicationController
  layout "menu"
  # GET /salary_levels
  # GET /salary_levels.xml
  def index
    @salary_levels = SalaryLevel.find_all_level params[:page]
    @salary_level=SalaryLevel.new
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @salary_levels }
    end
  end

  # GET /salary_levels/1
  # GET /salary_levels/1.xml
  def show
    @salary_level = SalaryLevel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @salary_level }
    end
  end

  # GET /salary_levels/1/edit
  def edit
    @salary_level = SalaryLevel.find(params[:id])
  end

  # POST /salary_levels
  # POST /salary_levels.xml
  def create
    @salary_level = SalaryLevel.new(params[:salary_level])

    respond_to do |format|
      if @salary_level.save
        flash[:notice] = "SalaryLevel #{@salary_level.name} was successfully created."
        format.html { redirect_to_index }
        format.xml  { render :xml => @salary_level, :status => :created, :location => @salary_level }
      else
        @salary_levels = SalaryLevel.find_all_level params[:page]
        format.html { render :action => "index" }
        format.xml  { render :xml => @salary_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /salary_levels/1
  # PUT /salary_levels/1.xml
  def update
    @salary_level = SalaryLevel.find(params[:id])

    respond_to do |format|
      if @salary_level.update_attributes(params[:salary_level])
        flash[:notice] = "SalaryLevel #{@salary_level.name} was successfully updated."
        format.html { redirect_to_index }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @salary_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /salary_levels/1
  # DELETE /salary_levels/1.xml
  def destroy
    @salary_level = SalaryLevel.find(params[:id])
    begin
        @salary_level.destroy
        flash[:notice] = "SalaryLevel #{@salary_level.name} was deleted."
    rescue Exception => e
       flash[:notice] = e.message
    end
    respond_to do |format|
      format.html { redirect_to(salary_levels_url) }
      format.xml  { head :ok }
    end
  end
  
  private 
    def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
 
end
