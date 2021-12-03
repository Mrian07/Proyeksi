

class Story < WorkPackage
  extend ProyeksiApp::Backlogs::Mixins::PreventIssueSti

  def self.backlogs(project_id, sprint_ids, options = {})
    options.reverse_merge!(order: Story::ORDER,
                           conditions: Story.condition(project_id, sprint_ids))

    candidates = Story.where(options[:conditions]).order(Arel.sql(options[:order]))

    stories_by_version = Hash.new do |hash, sprint_id|
      hash[sprint_id] = []
    end

    candidates.each do |story|
      last_rank = if stories_by_version[story.version_id].size > 0
                    stories_by_version[story.version_id].last.rank
                  else
                    0
                  end

      story.rank = last_rank + 1
      stories_by_version[story.version_id] << story
    end

    stories_by_version
  end

  def self.sprint_backlog(project, sprint, options = {})
    Story.backlogs(project.id, [sprint.id], options)[sprint.id]
  end

  def self.at_rank(project_id, sprint_id, rank)
    Story.where(Story.condition(project_id, sprint_id))
         .joins(:status)
         .order(Arel.sql(Story::ORDER))
         .offset(rank - 1)
         .first
  end

  def self.types
    types = Setting.plugin_proyeksiapp_backlogs['story_types']
    return [] if types.blank?

    types.map { |type| Integer(type) }
  end

  def tasks
    Task.tasks_for(id)
  end

  def tasks_and_subtasks
    return [] unless Task.type

    descendants.where(type_id: Task.type)
  end

  def direct_tasks_and_subtasks
    return [] unless Task.type

    children.where(type_id: Task.type).map { |t| [t] + t.descendants }.flatten
  end

  def set_points(p)
    init_journal(User.current)

    if p.blank? || p == '-'
      update_attribute(:story_points, nil)
      return
    end

    if p.downcase == 's'
      update_attribute(:story_points, 0)
      return
    end

    p = Integer(p)
    if p >= 0
      update_attribute(:story_points, p)
      nil
    end
  end

  # TODO: Refactor and add tests
  #
  # groups = tasks.partion(&:closed?)
  # {:open => tasks.last.size, :closed => tasks.first.size}
  #
  def task_status
    closed = 0
    open = 0

    tasks.each do |task|
      if task.closed?
        closed += 1
      else
        open += 1
      end
    end

    { open: open, closed: closed }
  end

  def rank=(r)
    @rank = r
  end

  def rank
    if position.blank?
      extras = [
        "and ((#{WorkPackage.table_name}.position is NULL and #{WorkPackage.table_name}.id <= ?) or not #{WorkPackage.table_name}.position is NULL)", id
      ]
    else
      extras = ["and not #{WorkPackage.table_name}.position is NULL and #{WorkPackage.table_name}.position <= ?", position]
    end

    @rank ||= WorkPackage.where(Story.condition(project.id, version_id, extras))
              .joins(:status)
              .count
    @rank
  end

  def self.condition(project_id, sprint_ids, extras = [])
    c = ['project_id = ? AND type_id in (?) AND version_id in (?)',
         project_id, Story.types, sprint_ids]

    if extras.size > 0
      c[0] += ' ' + extras.shift
      c += extras
    end

    c
  end

  # This forces NULLS-LAST ordering
  ORDER = "CASE WHEN #{WorkPackage.table_name}.position IS NULL THEN 1 ELSE 0 END ASC, CASE WHEN #{WorkPackage.table_name}.position IS NULL THEN #{WorkPackage.table_name}.id ELSE #{WorkPackage.table_name}.position END ASC"
end
