# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_BelgianDataPortal_session',
  :secret      => 'f165f5817191823ab4ea3cb448f349500c2fe84751b604044c9c2f82a5e1e0492f795a88699745b8b23ba5effd6f9f8c73d062d9862c6deb533939731977b595'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
