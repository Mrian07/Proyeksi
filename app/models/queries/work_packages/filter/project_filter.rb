#-- encoding: UTF-8

class Queries::WorkPackages::Filter::ProjectFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  def allowed_values
    @allowed_values ||= begin
                          project_values = []
                          Project.project_tree(visible_projects) do |p, level|
                            prefix = (level > 0 ? ('--' * level + ' ') : '')
                            project_values << ["#{prefix}#{p.name}", p.id.to_s]
                          end

                          project_values
                        end
  end

  def available?
    !project && visible_projects.exists?
  end

  def type
    :list
  end

  def self.key
    :project_id
  end

  def ar_object_filter?
    true
  end

  def value_objects
    available_projects = visible_projects.index_by(&:id)

    values
      .map { |project_id| available_projects[project_id.to_i] }
      .compact
  end

  private

  def visible_projects
    @visible_projects ||= Project.visible.active
  end
end
