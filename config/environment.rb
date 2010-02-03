# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require "smtp_tls"
Rails::Initializer.run do |config|

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
#   config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "fastercsv", :lib => "faster_csv"
  config.gem "openrain-action_mailer_tls", :lib => "smtp_tls.rb"
  config.gem 'gruff', :lib => 'gruff'
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

      # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_sis_session',
    :secret      => 'f914e9b1bbdb829688de8512f...9b1810a4e238a61dfd922dc9dd62521'
  }  
  
     # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store
  
  # config/environments/development.rb  
   config.action_mailer.raise_delivery_errors = true #错误异常是事抛给应用程序  
   config.action_mailer.perform_deliveries = true
   # set delivery method to :smtp, :sendmail or :test  
   config.action_mailer.delivery_method = :smtp # 发送邮件方式  
   config.action_mailer.default_charset = "utf-8"
    
  config.action_mailer.smtp_settings = {  
      :tls => true,
      :enable_starttls_auto => true,
      :address => "smtp.gmail.com",  
      :port => 587,  
      :authentication => :plain,  
      :user_name=> "tang.jilong@gmail.com",  
      :password => "tim83tang"
    }  
  
  
  
  
end
