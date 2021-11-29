#-- encoding: UTF-8



module Members::Scopes
  module Of
    extend ActiveSupport::Concern

    class_methods do
      # Find all members of a project
      def of(project)
        where(project_id: project)
      end
    end
  end
end
