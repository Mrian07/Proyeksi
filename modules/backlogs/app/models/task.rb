

require 'date'

class Task < WorkPackage
  extend OpenProject::Backlogs::Mixins::PreventIssueSti

  def self.type
    task_type = Setting.plugin_openproject_backlogs['task_type']
    task_type.blank? ? nil : task_type.to_i
  end

  # This method is used by Backlogs::List. It ensures, that tasks and stories
  # follow a similar interface
  def self.types
    [type]
  end

  def self.tasks_for(story_id)
    Task.children_of(story_id).order(:position).each_with_index do |task, i|
      task.rank = i + 1
    end
  end

  def status_id=(id)
    super
    self.remaining_hours = 0 if Status.find(id).is_closed?
  end

  def rank=(r)
    @rank = r
  end

  attr_reader :rank
end
