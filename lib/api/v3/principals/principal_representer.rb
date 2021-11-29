#-- encoding: UTF-8



require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module Principals
      class PrincipalRepresenter < ::API::Decorators::Single
        include AvatarHelper
        include API::Decorators::DateProperty
        include ::API::Caching::CachedRepresenter

        self_link

        link :memberships,
             cache_if: -> { current_user_allowed_to_see_members? } do
          filters = [
            {
              principal: {
                operator: '=',
                values: [represented.id.to_s]
              }
            }
          ]

          {
            href: api_v3_paths.path_for(:memberships, filters: filters),
            title: I18n.t(:label_member_plural)
          }
        end

        property :id,
                 render_nil: true

        property :name,
                 render_nil: true

        date_time_property :created_at,
                           cache_if: -> { current_user_is_admin_or_self }

        date_time_property :updated_at,
                           cache_if: -> { current_user_is_admin_or_self }

        def current_user_is_admin_or_self
          current_user_is_admin? || current_user_is_self?
        end

        def current_user_is_admin?
          current_user.admin?
        end

        def current_user_is_self?
          represented.id == current_user.id
        end

        def current_user_allowed_to_see_members?
          current_user.allowed_to_globally?(:view_members) ||
            current_user.allowed_to_globally?(:manage_members)
        end
      end
    end
  end
end
