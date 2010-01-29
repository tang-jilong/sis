# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "menu" 
  before_filter :authorize, :except => :login
  before_filter :set_locale
#  before_filter :configure_charsets  
  

  
  helper :all # include all helpers, all the time
  protect_from_forgery :secret => '8fc080370e56e929a2d5afca5540a0f7'
  
#  def configure_charsets  
#    headers["Content-Type"]="text/html;charset=utf-8"  
#  end    
  
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  def authorize
    unless User.find_by_id(session[:user_id])
      flash[:login_notice] = "application.login_msg.welcome_msg"
      redirect_to :controller => 'login', :action => 'login'
    end
    @menu = session[:menu]
  end
  
  
  
  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
    locale_path = "#{LOCALES_DIRECTORY}#{I18n.locale}.yml"
    unless I18n.load_path.include? locale_path
      I18n.load_path << locale_path
      I18n.backend.send(:init_translations)
    end
  rescue Exception => err
    logger.error err
    flash.now[:notice] = "#{I18n.locale} translation not available"
    I18n.load_path -= [locale_path]
    I18n.locale = session[:locale] = I18n.default_locale
  end
end
