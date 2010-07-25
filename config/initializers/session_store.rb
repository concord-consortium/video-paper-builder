# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_video-paper-builder_session',
  :secret      => 'eb94f540b4d5776cc41deba738297a6572580c6cf6826ff4b93adbdf715f523ea243fe4f39f1418d32f35d1c775931dbedea2ba4355f14914a3e7ccba0cb9bde'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
