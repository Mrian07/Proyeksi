#-- encoding: UTF-8



begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    files = ['lib/**/*.rb', 'app/**/*.rb']
    files << Dir['vendor/plugins/**/*.rb'].reject { |f| f.match(/test/) } # Exclude test files
    t.files = files

    static_files = ['doc/CHANGELOG.rdoc',
                    'doc/COPYING.rdoc',
                    'doc/COPYRIGHT.rdoc',
                    'doc/INSTALL.rdoc',
                    'doc/RUNNING_TESTS.rdoc',
                    'doc/UPGRADING.rdoc'].join(',')

    t.options += ['--output-dir', './doc/app', '--files', static_files]
  end
rescue LoadError
  # yard not installed (gem install yard)
  # http://yardoc.org
end
