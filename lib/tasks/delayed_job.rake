#-- encoding: UTF-8



##
# Enhance the delayed_job prerequisites rake task to load the environment
unless Rake::Task.task_defined?('jobs:environment_options') &&
       Rake::Task['jobs:work'].prerequisites == %w(environment_options)
  raise "Trying to load the full environment for delayed_job, but jobs:work seems to have changed."
end

Rake::Task['jobs:environment_options']
  .clear_prerequisites
  .enhance(['environment:full'])

# Enhance delayed job workers to use cron
load 'lib/tasks/cron.rake'
Rake::Task["jobs:work"].enhance [:"proyeksiapp:cron:schedule"]
Rake::Task["jobs:workoff"].enhance [:"proyeksiapp:cron:schedule"]
