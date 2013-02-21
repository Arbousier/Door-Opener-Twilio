#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

task :spec_check do
  if system("bundle exec rspec")
    system("bundle exec cane --abc-glob '{app,lib,spec}/**/*.rb' --abc-max 15")
  end
end
