

module OpenProject::Backlogs::Patches::Versions::BaseContractPatch
  private

  def user_allowed_to_manage
    changed_settings = model.version_settings.select(&:changed?)

    super unless !model.changed? && changed_settings.any?

    # Make sure the version_settings (column=left|right|none) can only be stored
    # for projects the user has the :manage_versions permission in.
    changed_settings.each do |version_setting|
      unless user.allowed_to?(:manage_versions, Project.find_by(id: version_setting.project_id))
        errors.add :base, :error_unauthorized
      end
    end
  end
end
