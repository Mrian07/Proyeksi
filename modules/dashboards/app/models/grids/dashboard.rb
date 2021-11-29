#-- encoding: UTF-8



module Grids
  class Dashboard < Grid
    belongs_to :project

    set_acts_as_attachable_options view_permission: :view_dashboards,
                                   delete_permission: :manage_dashboards,
                                   add_permission: :manage_dashboards
  end
end
