module WorkPackages::SkipAuthorizationChecks
  def user_allowed_to_add; end

  def validate_user_allowed_to_set_parent; end

  def user_allowed_to_access; end

  def user_allowed_to_edit; end

  def user_allowed_to_move; end

  def reduce_by_writable_permissions(attributes)
    attributes
  end
end
