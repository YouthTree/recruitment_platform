# Backtrace Silencer

# Rails.backtrace_cleaner.add_silencer { |line| line =~ /my_noisy_library/ }
# Rails.backtrace_cleaner.remove_silencers!

# Inflections

# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Mime Types

# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

# Secret Token

RecruitmentPlatform::Application.config.secret_token = Settings.session_key

# Session Store

RecruitmentPlatform::Application.config.session_store :cookie_store, :key => Settings.fetch(:session_key, '_recruitment_platform_session')


