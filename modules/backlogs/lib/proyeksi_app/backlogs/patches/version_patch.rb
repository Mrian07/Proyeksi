

require_dependency 'version'

module ProyeksiApp::Backlogs::Patches::VersionPatch
  def self.included(base)
    base.class_eval do
      has_many :version_settings, dependent: :destroy
      accepts_nested_attributes_for :version_settings

      include InstanceMethods
    end
  end

  module InstanceMethods
    def rebuild_story_positions(project = self.project)
      return unless project.backlogs_enabled?

      WorkPackage.transaction do
        # Remove position from all non-stories
        WorkPackage.where(['project_id = ? AND type_id NOT IN (?) AND position IS NOT NULL', project, Story.types])
          .update_all(position: nil)

        rebuild_positions(work_packages.where(project_id: project), Story.types)
      end

      nil
    end

    def rebuild_task_positions(task)
      return unless task.project.backlogs_enabled?

      WorkPackage.transaction do
        # Add work_packages w/o position to the top of the list and add
        # work_packages, that have a position, at the end
        rebuild_positions(task.story.children.where(project_id: task.project), Task.type)
      end

      nil
    end

    def ==(other)
      super ||
        other.is_a?(self.class) &&
          id.present? &&
          other.id == id
    end

    def eql?(other)
      self == other
    end

    def hash
      id.hash
    end

    private

    def rebuild_positions(scope, type_ids)
      wo_position = scope
                      .where(type_id: type_ids,
                             position: nil)
                      .order(Arel.sql('id'))

      w_position = scope
                     .where(type_id: type_ids)
                     .where.not(position: nil)
                     .order(Arel.sql('COALESCE(position, 0), id'))

      (w_position + wo_position).each_with_index do |work_package, index|
        work_package.update_column(:position, index + 1)
      end
    end
  end
end

Version.include ProyeksiApp::Backlogs::Patches::VersionPatch
