#-- encoding: UTF-8

class CustomActions::Conditions::Role < CustomActions::Conditions::Base
  def fulfilled_by?(work_package, user)
    values.empty? ||
      (self.class.roles_in_project(work_package, user).map(&:id) & values).any?
  end

  class << self
    def key
      :role
    end

    def roles_in_project(work_packages, user)
      with_request_store(projects_of(work_packages)) do |projects|
        projects.map do |project|
          user.roles_for_project(project)
        end.flatten
      end
    end

    private

    def custom_action_scope_has_current(work_packages, user)
      CustomAction
        .includes(association_key)
        .where(habtm_table => { key_id => roles_in_project(work_packages, user) })
    end

    def projects_of(work_packages)
      # Using this if/else instead of Array(work_packages)
      # to avoid "delegator does not forward private method #to_ary" warnings
      # for WorkPackageEagerLoadingWrapper
      if work_packages.respond_to?(:map)
        work_packages.map(&:project).uniq
      else
        [work_packages.project]
      end
    end

    def with_request_store(projects)
      RequestStore.store[:custom_actions_role] ||= Hash.new do |hash, hash_projects|
        hash[hash_projects] = yield hash_projects
      end

      RequestStore.store[:custom_actions_role][projects]
    end
  end

  private

  def associated
    ::Role
      .givable
      .select(:id, :name)
      .map { |u| [u.id, u.name] }
  end
end
