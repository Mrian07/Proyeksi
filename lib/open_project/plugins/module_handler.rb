#-- encoding: UTF-8

project_module

module OpenProject::Plugins
  class ModuleHandler
    @@disabled_modules = []

    class << self
      def disable_modules(module_names)
        @@disabled_modules += Array(module_names).map(&:to_sym)
      end

      def disable(disabled_modules)
        disabled_modules.map do |module_name|
          OpenProject::AccessControl.remove_modules_permissions(module_name)
        end
      end
    end

    OpenProject::Application.config.to_prepare do
      OpenProject::Plugins::ModuleHandler.disable(@@disabled_modules)
    end
  end
end
