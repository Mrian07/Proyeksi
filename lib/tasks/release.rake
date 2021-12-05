#-- encoding: UTF-8



require 'fileutils'

desc 'Package up a ProyeksiApp release from git. example: `rake release[1.1.0]`'
task :release, [:version] do |_task, args|
  version = args[:version]
  abort 'Missing version in the form of 1.0.0' unless version.present?

  dir = Pathname.new(ENV['HOME']) + 'dev' + 'proyeksiapp' + 'packages'
  FileUtils.mkdir_p dir

  commands = [
    "cd #{dir}",
    "git clone git://github.com/opf/proyeksiapp.git proyeksiapp-#{version}",
    "cd proyeksiapp-#{version}/",
    "git checkout v#{version}",
    "rm -vRf #{dir}/proyeksiapp-#{version}/.git",
    "cd #{dir}",
    "tar -zcvf proyeksiapp-#{version}.tar.gz proyeksiapp-#{version}",
    "zip -r -9 proyeksiapp-#{version}.zip proyeksiapp-#{version}",
    "md5sum proyeksiapp-#{version}.tar.gz proyeksiapp-#{version}.zip > proyeksiapp-#{version}.md5sum",
    "echo 'Release ready'"
  ].join(' && ')
  system(commands)
end
