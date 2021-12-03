

require_dependency 'versions_controller'

module ProyeksiApp::Backlogs::Patches::VersionsControllerPatch
  def self.included(base)
    base.class_eval do
      include VersionSettingsHelper
      helper :version_settings

      # Find project explicitly on update and edit
      skip_before_action :find_project_from_association, only: %i[edit update]
      skip_before_action :find_model_object, only: %i[edit update]
      prepend_before_action :find_project_and_version, only: %i[edit update]

      before_action :add_project_to_version_settings_attributes, only: %i[update create]

      before_action :whitelist_update_params, only: :update

      def whitelist_update_params
        if @project != @version.project
          # Make sure only the version_settings_attributes
          # (column=left|right|none) can be stored when current project does not
          # equal the version project (which is valid in inherited versions)
          if permitted_params.version.present? && permitted_params.version[:version_settings_attributes].present?
            params['version'] = { version_settings_attributes: permitted_params.version[:version_settings_attributes] }
          else
            # This is an unfortunate hack giving how plugins work at the moment.
            # In this else branch we want the `version` to be an empty hash.
            permitted_params.define_singleton_method :version, lambda { {} }
          end
        end
      end

      def find_project_and_version
        find_model_object
        if params[:project_id]
          find_project
        else
          find_project_from_association
        end
      end

      # This forces the current project for the nested version settings in order
      # to prevent it from being set through firebug etc. #mass_assignment
      def add_project_to_version_settings_attributes
        if permitted_params.version['version_settings_attributes'].present?
          params['version']['version_settings_attributes'].each do |attr_hash|
            attr_hash['project_id'] = @project.id
          end
        end
      end
    end
  end
end

VersionsController.include ProyeksiApp::Backlogs::Patches::VersionsControllerPatch
