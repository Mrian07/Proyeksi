# A contract that only checks whether the current user is an admin
class AdminOnlyContract < ::ModelContract
  include RequiresAdminGuard

  protected

  def validate_model?
    false
  end
end
