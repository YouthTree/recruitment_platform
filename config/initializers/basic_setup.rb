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

RecruitmentPlatform::Application.config.secret_token = '49be4bd6dd520945a6e149ef3b538895024a0e2e5ec235769bd0b257d0078b90dc6da3114d8d35f3900e8702e461366178ed7775f8cf818e3c9b4907b834978b'

# Session Store

RecruitmentPlatform::Application.config.session_store :cookie_store, :key => '_recruitment_platform_session'


