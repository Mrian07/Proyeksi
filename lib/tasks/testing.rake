#-- encoding: UTF-8



namespace :test do
  desc 'runs all tests'
  namespace :suite do
    task run: [:spec, 'spec:legacy']
  end
end

task('spec:legacy').clear

namespace :spec do
  require 'rspec/core/rake_task'

  desc 'Run the code examples in spec_legacy'
  task legacy: %w(legacy:unit legacy:functional legacy:integration)
  namespace :legacy do
    %w(unit functional integration).each do |type|
      desc "Run the code examples in spec_legacy/#{type}"
      RSpec::Core::RakeTask.new(type => 'spec:prepare') do |t|
        t.pattern = "spec_legacy/#{type}/**/*_spec.rb"
        t.rspec_opts = '-I spec_legacy'
      end
    end
  end
rescue LoadError
  # when you bundle without development and test (e.g. to create a deployment
  # artefact) still all tasks get loaded. To avoid an error we rescue here.
end

%w(spec).each do |type|
  if Rake::Task.task_defined?("#{type}:prepare")
    Rake::Task["#{type}:prepare"].enhance(['assets:prepare_op'])
  end
end
