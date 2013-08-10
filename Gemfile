source 'http://rubygems.org'

def gh(user, repo)
  "git://github.com/#{user}/#{repo}.git"
end

gem 'rails', '~> 3.0.3'
gem 'pg'
gem 'json'

# General frontend

gem 'haml-rails', '~> 0.3.0'
gem 'haml'
gem 'compass', '0.10.5'
gem 'compass-colors'

gem 'formtastic', '~> 1.2'
gem 'validation_reflection', '~> 1.0.0'
gem 'title_estuary', :git => 'git://github.com/thefrontiergroup/title_estuary.git'
gem 'inherited_resources', '~> 1.2.1'
gem 'show_for', '~> 0.2.4'

gem 'uuid'
gem 'stringex'
gem 'slugged'
gem 'almost-happy'
gem 'orderable'

gem 'youthtree-settings'
gem 'youthtree-controller-ext'
gem 'bhm-admin', '~> 0.3.4'

gem 'will_paginate', '~> 3.0.pre2', :git => gh('mislav', 'will_paginate'), :branch => 'rails3'

gem 'barista',           '>= 0.7.0.pre2'
gem 'shuriken',          '~> 0.2'
gem 'youthtree-js',      '~> 0.2'
gem 'youthtree-helpers', '~> 0.2'

gem 'jammit', '~> 0.6.0'

gem 'devise', '~> 1.1.8'
gem 'devise_imapable', '~> 0.5.1', :git => gh('YouthTree', 'devise_imapable')

gem 'awesome_print'

gem 'pdfkit', '~> 0.5.0'

gem 'acts_as_indexed', '~> 0.7.1'

gem 'nokogiri', '~> 1.5.0'

gem 'fastercsv'

gem 'state_machine'

gem 'meta_where', '~> 1.0.4'

group :test, :development do
  gem 'rspec',       '~> 2.1'
  gem 'rspec-rails', '~> 2.1'
  gem 'machinist',   '>= 2.0.0.beta2', :require => 'machinist/active_record'
  gem 'forgery',                       :require => 'forgery'
  gem 'dataset', :git => 'git://github.com/radiant/dataset.git'
  gem 'ruby-debug'
end

group :test do
  gem 'remarkable',              '>= 4.0.0.alpha4', :require => 'remarkable/core'
  gem 'remarkable_activerecord', '>= 4.0.0.alpha4', :require => 'remarkable/active_record'
  gem 'rr'
  gem 'rcov', :require => nil
  gem 'rspec_tag_matchers'
  gem 'syntax', :require => nil
  gem 'email_spec'
  gem 'ci_reporter', '~> 1.6.3', :require => nil
end

group :staging, :production do
  # gem 'therubyracer', :require => nil
  gem 'unicorn', :require => nil
end
