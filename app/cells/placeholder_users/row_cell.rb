

module PlaceholderUsers
  class RowCell < ::RowCell
    include AvatarHelper
    include UsersHelper
    include PlaceholderUsersHelper
    include TooltipHelper

    def placeholder_user
      model
    end

    def name
      link_to h(placeholder_user.name), edit_placeholder_user_path(placeholder_user)
    end

    def button_links
      [delete_link].compact
    end

    def delete_link
      if can_delete_placeholder_user?(placeholder_user, User.current)
        link_to deletion_info_placeholder_user_path(placeholder_user) do
          tooltip_tag I18n.t('placeholder_users.delete_tooltip'), icon: 'icon-delete'
        end
      else
        tooltip_tag I18n.t('placeholder_users.right_to_manage_members_missing'), icon: 'icon-help2'
      end
    end

    def row_css_class
      "placeholder_user"
    end
  end
end
