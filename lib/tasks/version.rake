#-- encoding: UTF-8



require 'proyeksi_app/version'
desc 'Displays the current version of ProyeksiApp'
task :version do
  puts ::ProyeksiApp::VERSION.to_semver
end
