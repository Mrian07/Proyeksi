#-- encoding: UTF-8



module API
  module V3
    module Memberships
      class MembershipRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource
        include API::Decorators::DateProperty

        self_link title_getter: ->(*) { represented.principal&.name }

        link :schema do
          {
            href: api_v3_paths.membership_schema
          }
        end

        link :update do
          next unless current_user_allowed_to(:manage_members, context: represented.project)

          {
            href: api_v3_paths.membership_form(represented.id),
            method: :post
          }
        end

        link :updateImmediately do
          next unless current_user_allowed_to(:manage_members, context: represented.project)

          {
            href: api_v3_paths.membership(represented.id),
            method: :patch
          }
        end

        property :id

        associated_resource :project

        associated_resource :principal,
                            getter: ::API::V3::Principals::PrincipalRepresenterFactory
                                      .create_getter_lambda(:principal),
                            setter: ::API::V3::Principals::PrincipalRepresenterFactory
                                      .create_setter_lambda(:user),
                            link: ::API::V3::Principals::PrincipalRepresenterFactory
                                    .create_link_lambda(:principal, getter: 'user_id')

        associated_resources :roles,
                             getter: ->(*) do
                               unmarked_roles.map do |role|
                                 API::V3::Roles::RoleRepresenter.new(role, current_user: current_user)
                               end
                             end,
                             link: ->(*) do
                               unmarked_roles.map do |role|
                                 ::API::Decorators::LinkObject
                                   .new(role,
                                        property_name: :itself,
                                        path: :role,
                                        getter: :id,
                                        title_attribute: :name)
                                   .to_hash
                               end
                             end

        date_time_property :created_at
        date_time_property :updated_at

        self.to_eager_load = %i[principal
                                project
                                roles]

        def _type
          'Membership'
        end

        def unmarked_roles
          represented
            .member_roles
            .reject(&:marked_for_destruction?)
            .map(&:role)
            .uniq
        end
      end
    end
  end
end
