#-- encoding: UTF-8

module AuthenticationStagePathHelper
  def authentication_stage_complete_path(identifier)
    ProyeksiApp::Authentication::Stage.complete_path identifier, session: session
  end

  def authentication_stage_failure_path(identifier)
    ProyeksiApp::Authentication::Stage.failure_path identifier
  end
end
