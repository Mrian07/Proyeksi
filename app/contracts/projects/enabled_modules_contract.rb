

module Projects
  class EnabledModulesContract < ModelContract
    validate :validate_permission
    validate :validate_dependencies_met

    protected

    def validate_model?
      false
    end

    def validate_permission
      errors.add :base, :error_unauthorized unless user.allowed_to?(:select_project_modules, model)
    end

    def validate_dependencies_met
      enabled_modules_with_dependencies
        .each do |mod|
        (mod[:dependencies] - model.enabled_module_names.map(&:to_sym)).each do |dep|
          errors.add(:enabled_modules,
                     :dependency_missing,
                     dependency: I18n.t("project_module_#{dep}"),
                     module: I18n.t("project_module_#{mod[:name]}"))
        end
      end
    end

    def enabled_modules_with_dependencies
      ProyeksiApp::AccessControl
        .modules
        .select { |m| model.enabled_module_names.include?(m[:name].to_s) && m[:dependencies] }
    end
  end
end
