#-- encoding: UTF-8

class Queries::WorkPackages::Filter::PrincipalLoader
  attr_accessor :project

  def initialize(project)
    self.project = project
  end

  def user_values
    @user_values ||= if principals_by_class[User].present?
                       principals_by_class[User].map { |s| [s.name, s.id.to_s] }.sort
                     else
                       []
                     end
  end

  def group_values
    @group_values ||= if principals_by_class[Group].present?
                        principals_by_class[Group].map { |s| [s.name, s.id.to_s] }.sort
                      else
                        []
                      end
  end

  def principal_values
    @options ||= principals.map { |s| [s.name, s.id.to_s] }.sort
  end

  private

  def principals
    if project
      project.principals.sort
    else
      Principal.not_locked.in_visible_project.sort
    end
  end

  def principals_by_class
    @principals_by_class ||= principals.group_by(&:class)
  end
end
