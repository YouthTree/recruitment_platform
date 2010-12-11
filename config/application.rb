require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module RecruitmentPlatform
  class Application < Rails::Application
    # config.autoload_paths += %W(#{config.root}/extras)
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    # config.time_zone = 'Central Time (US & Canada)'
    # config.i18n.default_locale = :de
    
    config.action_view.javascript_expansions[:defaults] = %w(vendor/jquery vendor/rails)
    
    config.encoding           = "utf-8"
    config.time_zone          = Settings.time_zone
    config.filter_parameters += [:password]
  end
end
