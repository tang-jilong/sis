# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sis_session',
  :secret      => '874920ea4bad44c164e0a9bd1960d8fa69a61cdb76da148b127419da7f105052f24ddbe8a637b40e70c187aea9838b11b0d605b8b3471a17f87bec434d4e00f1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
