#-- encoding: UTF-8



module Grids
  class MyPage < Grid
    belongs_to :user

    # The requirement on view_project is more or less arbitrary.
    # We need a permission here and view_project is a public one so everybody
    # should have it.
    # In the long run it would be better to have a global permission to
    # maintain a my page.
    set_acts_as_attachable_options view_permission: :view_project,
                                   delete_permission: :view_project,
                                   add_permission: :view_project,
                                   only_user_allowed: true
  end
end
