#-- encoding: UTF-8



class Enterprise
  def self.matches?(_request)
    ProyeksiApp::Configuration.ee_manager_visible?
  end
end
