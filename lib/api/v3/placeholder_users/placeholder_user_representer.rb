#-- encoding: UTF-8



module API
  module V3
    module PlaceholderUsers
      class PlaceholderUserRepresenter < ::API::V3::Principals::PrincipalRepresenter
        link :updateImmediately,
             cache_if: -> { current_user_can_manage? } do
          {
            href: api_v3_paths.placeholder_user(represented.id),
            title: "Update #{represented.name}",
            method: :patch
          }
        end

        link :delete,
             cache_if: -> { current_user_can_manage? } do
          {
            href: api_v3_paths.placeholder_user(represented.id),
            title: "Delete #{represented.name}",
            method: :delete
          }
        end

        link :showUser do
          {
            href: api_v3_paths.placeholder_user_path(represented.id),
            type: 'text/html'
          }
        end


        def _type
          'PlaceholderUser'
        end

        def current_user_can_manage?
          current_user&.allowed_to_globally?(:manage_placeholder_user)
        end
      end
    end
  end
end
