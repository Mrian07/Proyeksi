#-- encoding: UTF-8



if OpenProject::Configuration.disabled_modules.any?
  to_disable = OpenProject::Configuration.disabled_modules
  OpenProject::Plugins::ModuleHandler.disable_modules(to_disable)
end
