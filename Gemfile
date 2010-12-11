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
gem 'compass'
gem 'compass-colors'
gem 'fancy-buttons'

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
gem 'bhm-admin'

gem 'will_paginate', '~> 3.0.pre2', :git => gh('mislav', 'will_paginate'), :branch => 'rails3'

gem 'therubyracer'
gem 'barista',           '>= 0.7.0.pre2'
gem 'shuriken',          '~> 0.2'
gem 'bhm-google-maps',   '~> 0.3'
gem 'youthtree-js',      '~> 0.2'
gem 'youthtree-helpers', '~> 0.1'

group :development do
  gem 'rails3-generators'
  gem 'mongrel'
  gem 'annotate', :git => gh('miyucy', 'annotate_models'), :require => nil
end

group :test, :development do
  gem 'rspec',       '~> 2.1'
  gem 'rspec-rails', '~> 2.1'
  gem 'machinist',   '>= 2.0.0.beta2', :require => nil
  gem 'forgery',                       :require => nil
end

group :test do
  gem 'ZenTest'
  gem 'remarkable',              '>= 4.0.0.alpah4', :require => 'remarkable/core'
  gem 'remarkable_activerecord', '>= 4.0.0.alpah4', :require => 'remarkable/active_record'
  gem 'rr'
end

group :test_mac do
  gem 'autotest-growl'
  gem 'autotest-fsevent'
end

group :staging, :production do
  gem 'therubyracer', :require => nil
  gem 'hoptoad_notifier'
end