#-- encoding: UTF-8

class Queries::WorkPackages::Filter::PriorityFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  def allowed_values
    priorities.map { |s| [s.name, s.id.to_s] }
  end

  def available?
    priorities.exists?
  end

  def type
    :list
  end

  def self.key
    :priority_id
  end

  def ar_object_filter?
    true
  end

  def value_objects
    available_priorities = priorities.index_by(&:id)

    values
      .map { |priority_id| available_priorities[priority_id.to_i] }
      .compact
  end

  private

  def priorities
    @priorities ||= IssuePriority.active
  end
end
