#-- encoding: UTF-8



require 'fileutils'

desc 'Package up a OpenProject release from git. example: `rake release[1.1.0]`'
task :release, [:version] do |_task, args|
  version = args[:version]
  abort 'Missing version in the form of 1.0.0' unless version.present?

  dir = Pathname.new(ENV['HOME']) + 'dev' + 'openproject' + 'packages'
  FileUtils.mkdir_p dir

  commands = [
    "cd #{dir}",
    "git clone git://github.com/opf/openproject.git openproject-#{version}",
    "cd openproject-#{version}/",
    "git checkout v#{version}",
    "rm -vRf #{dir}/openproject-#{version}/.git",
    "cd #{dir}",
    "tar -zcvf openproject-#{version}.tar.gz openproject-#{version}",
    "zip -r -9 openproject-#{version}.zip openproject-#{version}",
    "md5sum openproject-#{version}.tar.gz openproject-#{version}.zip > openproject-#{version}.md5sum",
    "echo 'Release ready'"
  ].join(' && ')
  system(commands)
end
