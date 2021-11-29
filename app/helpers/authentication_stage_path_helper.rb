#-- encoding: UTF-8



module AuthenticationStagePathHelper
  def authentication_stage_complete_path(identifier)
    OpenProject::Authentication::Stage.complete_path identifier, session: session
  end

  def authentication_stage_failure_path(identifier)
    OpenProject::Authentication::Stage.failure_path identifier
  end
end
