Devise.setup do |config|
  config.mailer_sender = Settings.mailer.from

  require 'devise/orm/active_record'

  # config.mailer = "Devise::Mailer"
  # config.authentication_keys = [ :email ]
  # config.params_authenticatable = true
  # config.http_authenticatable = false
  # config.http_authenticatable_on_xhr = true
  # config.http_authentication_realm = "Application"

  config.stretches  = 10
  config.encryptor  = :bcrypt
  config.pepper     = Settings.devise.pepper
  config.timeout_in = 1.week


  # config.confirm_within = 2.days
  # config.remember_for = 2.weeks
  # config.remember_across_browsers = true
  # config.extend_remember_period = false
  # config.password_length = 6..20
  # config.email_regexp = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  # config.lock_strategy = :failed_attempts
  # config.unlock_strategy = :both
  # config.maximum_attempts = 20
  # config.unlock_in = 1.hour
  # config.token_authentication_key = :auth_token
  # config.scoped_views = true
  # config.default_scope = :user
  # config.sign_out_all_scopes = false

  config.imap_server               = Settings.devise.imap_server
  config.imap_default_email_suffix = Settings.devise.authentication_domain
  config.imap_server_use_ssl       = Settings.devise.ssl_for_imap
  config.imap_email_validator      = lambda { |e| e.to_s.split("@", 2).last == Settings.devise.authentication_domain }

end
