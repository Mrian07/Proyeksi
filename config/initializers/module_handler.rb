#-- encoding: UTF-8



if ProyeksiApp::Configuration.disabled_modules.any?
  to_disable = ProyeksiApp::Configuration.disabled_modules
  ProyeksiApp::Plugins::ModuleHandler.disable_modules(to_disable)
end
