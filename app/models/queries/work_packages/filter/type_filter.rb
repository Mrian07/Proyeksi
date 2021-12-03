#-- encoding: UTF-8

class Queries::WorkPackages::Filter::TypeFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  def allowed_values
    @allowed_values ||= begin
                          types.map { |s| [s.name, s.id.to_s] }
                        end
  end

  def available?
    types.exists?
  end

  def type
    :list
  end

  def self.key
    :type_id
  end

  def ar_object_filter?
    true
  end

  def value_objects
    available_types = types.index_by(&:id)

    values
      .map { |type_id| available_types[type_id.to_i] }
      .compact
  end

  private

  def types
    project.nil? ? ::Type.order(Arel.sql('position')) : project.rolled_up_types
  end
end
