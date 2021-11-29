

module Members
  class CleanupService < ::BaseServices::BaseCallable
    def initialize(users, projects)
      self.users = users
      self.projects = Array(projects)

      super()
    end

    protected

    def perform(_params = {})
      prune_watchers
      unassign_categories

      ServiceResult.new(success: true)
    end

    attr_accessor :users,
                  :projects

    def prune_watchers
      Watcher.prune(user: users, project_id: project_ids)
    end

    def unassign_categories
      Category
        .where(assigned_to_id: users)
        .where(project_id: project_ids)
        .where.not(assigned_to_id: Member.assignable.of(projects).select(:user_id))
        .update_all(assigned_to_id: nil)
    end

    def project_ids
      projects.first.is_a?(Project) ? projects.map(&:id) : projects
    end

    def members_table
      Member.table_name
    end
  end
end
