# Delete the old task.

Rake.application.instance_eval do
  @tasks.delete "spec:rcov"
end

# Add the spec:rcov task.
namespace :spec do
  desc "Run all specs with rcov"
  RSpec::Core::RakeTask.new(:rcov => "db:test:prepare") do |t|
    t.rcov = true
    t.pattern = "./spec/**/*_spec.rb"
    t.rcov_opts = '--exclude /gems/,/Library/,/usr/,lib/tasks,.bundle,config,/lib/rspec/,/lib/rspec-,^spec/'
  end
end
