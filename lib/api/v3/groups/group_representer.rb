#-- encoding: UTF-8



module API
  module V3
    module Groups
      class GroupRepresenter < ::API::V3::Principals::PrincipalRepresenter
        include API::Decorators::LinkedResource

        def _type
          'Group'
        end

        link :delete,
             cache_if: -> { current_user.admin? } do
          {
            href: api_v3_paths.group(represented.id),
            method: :delete
          }
        end

        link :updateImmediately,
             cache_if: -> { current_user.admin? } do
          {
            href: api_v3_paths.group(represented.id),
            method: :patch
          }
        end

        associated_resources :users,
                             as: :members,
                             skip_render: -> { !current_user.allowed_to_globally?(:manage_members) }
      end
    end
  end
end
