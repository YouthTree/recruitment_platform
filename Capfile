require 'rubygems'
require 'bundler/setup'
require 'youthtree-capistrano'

set :application, "recruitment_platform"

set :bundle_without, [:development, :test, :test_mac]

# Use git-flow based branches for deployment.
set :branch do
  stage == "production" ? "master" : "develop"
end