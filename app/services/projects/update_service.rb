#-- encoding: UTF-8



module Projects
  class UpdateService < ::BaseServices::Update
    private

    attr_accessor :memoized_changes

    def set_attributes(params)
      ret = super

      # Because awesome_nested_set reloads the model after saving, we cannot rely
      # on saved_changes.
      self.memoized_changes = model.changes

      ret
    end

    def persist(service_result)
      # Needs to take place before awesome_nested_set reloads the model (in case the parent changes)
      persist_status

      super
    end

    def after_perform(service_call)
      touch_on_custom_values_update
      notify_on_identifier_renamed
      send_update_notification
      update_wp_versions_on_parent_change
      handle_archiving

      service_call
    end

    def touch_on_custom_values_update
      model.touch if only_custom_values_updated?
    end

    def notify_on_identifier_renamed
      return unless memoized_changes['identifier']

      ProyeksiApp::Notifications.send(ProyeksiApp::Events::PROJECT_RENAMED, project: model)
    end

    def send_update_notification
      ProyeksiApp::Notifications.send(ProyeksiApp::Events::PROJECT_UPDATED, project: model)
    end

    def only_custom_values_updated?
      !model.saved_changes? && model.custom_values.any?(&:saved_changes?)
    end

    def update_wp_versions_on_parent_change
      return unless memoized_changes['parent_id']

      WorkPackage.update_versions_from_hierarchy_change(model)
    end

    def persist_status
      model.status.save if model.status.changed?
    end

    def handle_archiving
      return unless model.saved_change_to_active?

      if model.active?
        # was unarchived
        Projects::UnarchiveService
          .new(user: user, model: model)
          .call
      else
        # as archived
        Projects::ArchiveService
          .new(user: user, model: model)
          .call
      end
    end
  end
end
