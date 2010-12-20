source 'http://rubygems.org'

def gh(user, repo)
  "git://github.com/#{user}/#{repo}.git"
end

gem 'rails', '3.0.3'
gem 'pg'
gem 'json'

# General frontend

gem 'haml-rails'
gem 'haml'
gem 'compass', '0.10.5'
gem 'compass-colors'

gem 'formtastic', '~> 1.2'
gem 'validation_reflection'
gem 'title_estuary'
gem 'inherited_resources'
gem 'show_for'

gem 'uuid'
gem 'stringex'
gem 'slugged'
gem 'almost-happy'

gem 'youthtree-settings'
gem 'youthtree-controller-ext'
gem 'bhm-admin', '~> 0.3.4'

gem 'will_paginate', '~> 3.0.pre2', :git => gh('mislav', 'will_paginate'), :branch => 'rails3'

gem 'therubyracer'
gem 'barista',           '>= 0.7.0.pre2'
gem 'shuriken',          '~> 0.2'
gem 'youthtree-js',      '~> 0.2'
gem 'youthtree-helpers', '~> 0.2'

gem 'jammit'

gem 'carrierwave'

gem 'validates_url_format_of'

gem 'devise'
gem 'devise_imapable', :git => gh('YouthTree', 'devise_imapable')

gem 'awesome_print'

group :development do
  gem 'rails3-generators'
  gem 'mongrel'
  gem 'annotate', :git => gh('miyucy', 'annotate_models'), :require => nil
  gem 'slurper', :require => nil
  gem 'capistrano', :require => nil
  gem 'youthtree-capistrano', :require => nil
end

group :test, :development do
  gem 'rspec',       '~> 2.1'
  gem 'rspec-rails', '~> 2.1'
  gem 'machinist',   '>= 2.0.0.beta2', :require => 'machinist/active_record'
  gem 'forgery',                       :require => 'forgery'
  # Guard basics
  gem 'guard', :require => nil
  gem 'guard-rspec', :require => nil
  gem 'guard-passenger', :require => nil
  gem 'ruby-debug'
end

group :test do
  gem 'remarkable',              '>= 4.0.0.alpha4', :require => 'remarkable/core'
  gem 'remarkable_activerecord', '>= 4.0.0.alpha4', :require => 'remarkable/active_record'
  gem 'rr'
  gem 'rcov', :require => nil
  gem 'rspec_tag_matchers'
  gem 'syntax', :require => nil
end

group :test_mac do
  gem 'rb-fsevent', :require => false
  gem 'growl', :require => false
end

group :staging, :production do
  gem 'therubyracer', :require => nil
  gem 'hoptoad_notifier'
  gem 'unicorn', :require => nil
end