

module ProyeksiApp::Backlogs::Compatibility
  def using_jquery?
    ProyeksiApp::Compatibility.respond_to?(:using_jquery?) and
      ProyeksiApp::Compatibility.using_jquery?
  rescue NameError
    false
  end

  extend self
end
