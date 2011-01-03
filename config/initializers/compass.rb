require 'compass'
require 'compass/app_integration/rails'
Compass::AppIntegration::Rails.initialize!

yt_sass_root = Rails.root.join("design", "sass").to_s
Compass::Frameworks.register 'youthtree', :path => yt_sass_root, :stylesheets_directory => yt_sass_root