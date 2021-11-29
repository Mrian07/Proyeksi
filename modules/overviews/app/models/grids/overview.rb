#-- encoding: UTF-8



module Grids
  class Overview < Grid
    belongs_to :project

    set_acts_as_attachable_options view_permission: :view_project,
                                   delete_permission: :manage_overview,
                                   add_permission: :manage_overview

    def to_s
      "Project '#{project&.name || 'missing'}' #{I18n.t('overviews.label')}"
    end
  end
end
