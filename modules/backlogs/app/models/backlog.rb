

class Backlog
  attr_accessor :sprint, :stories

  def self.owner_backlogs(project, options = {})
    options.reverse_merge!(limit: nil)

    backlogs = Sprint.apply_to(project).with_status_open.displayed_right(project).order_by_name

    stories_by_sprints = Story.backlogs(project.id, backlogs.map(&:id))

    backlogs.map { |sprint| new(stories: stories_by_sprints[sprint.id], owner_backlog: true, sprint: sprint) }
  end

  def self.sprint_backlogs(project)
    sprints = Sprint.apply_to(project).with_status_open.displayed_left(project).order_by_date

    stories_by_sprints = Story.backlogs(project.id, sprints.map(&:id))

    sprints.map { |sprint| new(stories: stories_by_sprints[sprint.id], sprint: sprint) }
  end

  def initialize(options = {})
    options = options.with_indifferent_access
    @sprint = options['sprint']
    @stories = options['stories']
    @owner_backlog = options['owner_backlog']
  end

  def updated_at
    @stories.max_by(&:updated_at).try(:updated_at)
  end

  def owner_backlog?
    !!@owner_backlog
  end

  def sprint_backlog?
    !owner_backlog?
  end
end
