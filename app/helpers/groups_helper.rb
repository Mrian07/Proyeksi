#-- encoding: UTF-8

module GroupsHelper
  def group_settings_tabs
    [
      {
        name: 'general',
        partial: 'groups/general',
        path: edit_group_path(@group),
        label: :label_general
      },
      {
        name: 'users',
        partial: 'groups/users',
        path: edit_group_path(@group, tab: :users),
        label: :label_user_plural
      },
      {
        name: 'memberships',
        partial: 'groups/memberships',
        path: edit_group_path(@group, tab: :memberships),
        label: :label_project_plural
      }
    ]
  end

  def set_filters_for_user_autocompleter
    @autocompleter_filters = []
    @autocompleter_filters.push({ selector: 'status', operator: '=', values: ['active', 'invited'] })
    @autocompleter_filters.push({ selector: 'group', operator: '!', values: [@group.id] })
  end
end
