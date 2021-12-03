module Versions
  class CreateContract < BaseContract
    attribute :project_id

    private

    def assignable_projects
      Project.allowed_to(user, :manage_versions)
    end
  end
end
