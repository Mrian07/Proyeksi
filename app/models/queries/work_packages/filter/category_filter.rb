#-- encoding: UTF-8



class Queries::WorkPackages::Filter::CategoryFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  def allowed_values
    all_project_categories.map { |s| [s.name, s.id.to_s] }
  end

  def available?
    project&.categories&.exists?
  end

  def type
    :list_optional
  end

  def self.key
    :category_id
  end

  def value_objects
    available_categories = all_project_categories.index_by(&:id)

    values
      .map { |category_id| available_categories[category_id.to_i] }
      .compact
  end

  def ar_object_filter?
    true
  end

  private

  def all_project_categories
    @all_project_categories ||= project.categories
  end
end
