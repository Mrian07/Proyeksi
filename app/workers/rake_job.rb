require 'rake'

##
# Invoke a rake task while safely loading the tasks only once
# to ensure they are neither loaded nor executed twice.
module RakeJob
  attr_reader :task_name, :args

  def perform(task_name, *args)
    @task_name = task_name
    @args = args

    Rails.logger.info { "Invoking Rake task #{task_name}." }
    invoke
  end

  protected

  def invoke
    load_tasks!
    task.invoke *args
  end

  ##
  # Load tasks if there are none. This should only be run once in an environment
  def load_tasks!
    ProyeksiApp::Application.load_rake_tasks unless tasks_loaded?
  end

  ##
  # Reference to the task name.
  # Will raise NameError or NoMethodError depending on what of rake is (not) loaded
  def task
    Rake::Task[task_name]
  end

  ##
  # Returns whether any task is loaded
  # Will raise NameError or NoMethodError depending on what of rake is (not) loaded
  def tasks_loaded?
    !Rake::Task.tasks.empty?
  end
end
