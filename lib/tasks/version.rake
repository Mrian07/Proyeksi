#-- encoding: UTF-8



require 'open_project/version'
desc 'Displays the current version of OpenProject'
task :version do
  puts ::OpenProject::VERSION.to_semver
end
