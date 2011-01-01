# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rr
  config.use_transactional_fixtures = true
  config.include CustomMatchers
  config.include RspecTagMatchers
  config.include I18nSpecHelper
  config.extend  DatasetCleanerHelper
  config.include Devise::TestHelpers, :type => :controller
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include MiscSpecExt
  config.before(:each) { Machinist.reset_before_test }
  config.after(:all)   { FileUtils.rm_rf Rails.root.join('index', Rails.env) }
  config.around(:each) { |s| BHM::Admin.silence_attr_accessible(&s) }

end
