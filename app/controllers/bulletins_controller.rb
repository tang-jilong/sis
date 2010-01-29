require 'iconv'
class BulletinsController < ApplicationController
  layout "menu"
  
   before_filter :configure_charsets  
  
  def configure_charsets  
    headers["Content-Type"]="text/html;charset=utf-8"  
  end    
  
  # GET /bulletins
  # GET /bulletins.xml
  def index
    @bulletins = Bulletin.find_all_bulletins params[:page]
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bulletins }
    end
  end

  # GET /bulletins/1
  # GET /bulletins/1.xml
  def show
    @bulletin = Bulletin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bulletin }
    end
  end

  # GET /bulletins/new
  # GET /bulletins/new.xml
  def new
    @bulletin = Bulletin.new
#    @post=""
#    @body=""
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bulletin }
    end
  end

  # GET /bulletins/1/edit
  def edit
    @bulletin = Bulletin.find(params[:id])
    @fDate=@bulletin.issue_date
  end
  
   def uploadFile(file)  
    if !file.original_filename.empty?  
      @filename=getFileName(file.original_filename)   
      File.open(Iconv.conv("GBK","utf-8","#{RAILS_ROOT}/public/upload/#{@filename}"), "wb") do |f|  
        f.write(file.read)  
      end  
      return @filename  
    end  
  end  
  
    def getFileName(filename) 
    if !filename.nil? 
      Time.now.strftime("%Y_%m_%d") + '_' + filename  
#    filename
    end  
  end  

  # POST /bulletins
  # POST /bulletins.xml
  def create
    @bulletin = Bulletin.new(params[:bulletin])
    fDate=params[:fDate]
    @bulletin.issue_date=fDate
    @bulletin.autor=session[:user_name]
    
#     unless request.get?  
#      filename=uploadFile(params[:file]['file'])  
#      @bulletin.file_name=filename
#    end  
    
    respond_to do |format|
      if @bulletin.save
        flash[:notice] = "Bulletin #{@bulletin.title} was successfully created."
        format.html { redirect_to_index }
        format.xml  { render :xml => @bulletin, :status => :created, :location => @bulletin }
      else
        @bulletins = Bulletin.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @bulletin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bulletins/1
  # PUT /bulletins/1.xml
  def update
    @bulletin = Bulletin.find(params[:id])
    fDate=params[:fDate]
    @bulletin.issue_date=fDate
    @bulletin.autor=session[:user_name]
    respond_to do |format|
      if @bulletin.update_attributes(params[:bulletin])
        flash[:notice] = "Bulletin #{@bulletin.title} was successfully updated."
        format.html { redirect_to_index }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bulletin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bulletins/1
  # DELETE /bulletins/1.xml
  def destroy
    @bulletin = Bulletin.find(params[:id])
     begin
      @bulletin.destroy
      flash[:notice] = "Bulletin #{@bulletin.title} was deleted"
    rescue Exception =>e
        flash[:notice] = e.message
     end
    respond_to do |format|
      format.html { redirect_to(bulletins_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
end
