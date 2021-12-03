#-- encoding: UTF-8

module Members::Scopes
  module Global
    extend ActiveSupport::Concern

    class_methods do
      # Find all members that are global, i.e. have not project
      def global
        where(project: nil)
      end
    end
  end
end
