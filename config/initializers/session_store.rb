# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_opinionlytics_session',
  :secret      => 'e536cf98e5c4642380d6527f7aa6bf4ba1d35a4504732e81519c18bc50b8d74a8fc6b7e15235ee92148d305251adec65a56c9568f3a50a91559ce0efa363158b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
