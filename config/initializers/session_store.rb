# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key => '_fc_session',
  :secret => '71fa3f20163341c4b4f8c8de6f625c33a367f5c20b24b94d2f3811b4629564422001ff1a7986833f4c9894e3d1adbf332c5799179e54bccde5f421a088fce039'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
 ActionController::Base.session_store = :active_record_store