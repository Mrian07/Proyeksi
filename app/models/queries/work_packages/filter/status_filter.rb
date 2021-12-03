#-- encoding: UTF-8

class Queries::WorkPackages::Filter::StatusFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def allowed_values
    all_statuses.values.map { |s| [s.name, s.id.to_s] }
  end

  def available_operators
    [Queries::Operators::OpenWorkPackages,
     Queries::Operators::Equals,
     Queries::Operators::ClosedWorkPackages,
     Queries::Operators::NotEquals,
     Queries::Operators::All]
  end

  def available?
    all_statuses.any?
  end

  def type
    :list
  end

  def self.key
    :status_id
  end

  def value_objects
    values
      .map { |status_id| all_statuses[status_id.to_i] }
      .compact
  end

  def allowed_objects
    all_statuses.values
  end

  def ar_object_filter?
    true
  end

  private

  def all_statuses
    key = 'Queries::WorkPackages::Filter::StatusFilter/all_statuses'

    RequestStore.fetch(key) do
      Status.all.to_a.index_by(&:id)
    end
  end

  def operator_strategy
    super_value = super

    if !super_value
      case operator
      when 'o'
        Queries::Operators::OpenWorkPackages
      when 'c'
        Queries::Operators::ClosedWorkPackages
      when '*'
        Queries::Operators::All
      end
    else
      super_value
    end
  end
end
