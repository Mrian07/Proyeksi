#-- encoding: UTF-8



module PlaceholderUsersHelper
  ##
  # Determine whether the given actor can delete the placeholder user
  def can_delete_placeholder_user?(placeholder, actor = User.current)
    PlaceholderUsers::DeleteContract.deletion_allowed? placeholder,
                                                       actor,
                                                       Authorization::UserAllowedService.new(actor)
  end
end
