#-- encoding: UTF-8

class Queries::Queries::Filters::ProjectIdentifierFilter < Queries::Queries::Filters::QueryFilter
  def type
    :list
  end

  def self.key
    :project_identifier
  end

  def joins
    :project
  end

  def where
    operator_strategy.sql_for_field(values, 'projects', 'identifier')
  end

  def allowed_values
    Project.visible.pluck(:name, :identifier)
  end
end
