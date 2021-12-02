

require_dependency 'project'

module ProyeksiApp::Backlogs::Patches::ProjectPatch
  def self.included(base)
    base.class_eval do
      has_and_belongs_to_many :done_statuses, join_table: :done_statuses_for_project, class_name: '::Status'

      include InstanceMethods
    end
  end

  module InstanceMethods
    def rebuild_positions
      return unless backlogs_enabled?

      shared_versions.each { |v| v.rebuild_positions(self) }
      nil
    end

    def backlogs_enabled?
      module_enabled? 'backlogs'
    end
  end
end

Project.include ProyeksiApp::Backlogs::Patches::ProjectPatch
