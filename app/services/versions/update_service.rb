#-- encoding: UTF-8

module Versions
  class UpdateService < ::BaseServices::Update
    private

    def after_perform(service_call)
      model.touch if only_custom_values_updated?
      update_wps_from_sharing_change if model.saved_change_to_sharing?
      service_call
    end

    # Update the issue's versions. Used if a version's sharing changes.
    def update_wps_from_sharing_change
      if no_valid_version_before_or_now? ||
        sharing_now_less_broad?
        WorkPackage.update_versions_from_sharing_change model
      end
    end

    def only_custom_values_updated?
      !model.saved_changes? && model.custom_values.any?(&:saved_changes?)
    end

    def no_valid_version_before_or_now?
      version_sharings.index(model.sharing_before_last_save).nil? ||
        version_sharings.index(model.sharing).nil?
    end

    def sharing_now_less_broad?
      version_sharings.index(model.sharing_before_last_save) > version_sharings.index(model.sharing)
    end

    def version_sharings
      Version::VERSION_SHARINGS
    end
  end
end
