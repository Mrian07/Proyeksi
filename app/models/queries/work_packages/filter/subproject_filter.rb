#-- encoding: UTF-8

class Queries::WorkPackages::Filter::SubprojectFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  def allowed_values
    @allowed_values ||= begin
                          visible_subproject_array.map { |id, name| [name, id.to_s] }
                        end
  end

  def default_operator
    ::Queries::Operators::All
  end

  def available?
    project &&
      !project.leaf? &&
      visible_subprojects.any?
  end

  def type
    :list_optional
  end

  def human_name
    I18n.t('query_fields.subproject_id')
  end

  def self.key
    :subproject_id
  end

  def ar_object_filter?
    true
  end

  def value_objects
    available_subprojects = visible_subprojects.index_by(&:id)

    values
      .map { |subproject_id| available_subprojects[subproject_id.to_i] }
      .compact
  end

  def where
    "#{Project.table_name}.id IN (%s)" % ids_for_where.join(',')
  end

  protected

  def ids_for_where
    [project.id] + ids_for_where_subproject
  end

  def ids_for_where_subproject
    case operator
    when ::Queries::Operators::Equals.symbol
      # include the selected subprojects
      value_ints
    when ::Queries::Operators::All.symbol
      visible_subproject_ids
    when ::Queries::Operators::NotEquals.symbol
      visible_subproject_ids - value_ints
    else
      # None
      []
    end
  end

  def visible_subproject_array
    visible_subprojects.pluck(:id, :name)
  end

  def visible_subprojects
    # This can be accessed even when `available?` is false
    @visible_subprojects ||= begin
                               if project.nil?
                                 []
                               else
                                 project.descendants.visible
                               end
                             end
  end

  def visible_subproject_ids
    visible_subproject_array.map(&:first)
  end

  def value_ints
    values.map(&:to_i)
  end
end
