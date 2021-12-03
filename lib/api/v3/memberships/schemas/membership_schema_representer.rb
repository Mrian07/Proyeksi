module API
  module V3
    module Memberships
      module Schemas
        class MembershipSchemaRepresenter < ::API::Decorators::SchemaRepresenter
          def initialize(represented, self_link: nil, current_user: nil, form_embedded: false)
            super(represented,
                  self_link: self_link,
                  current_user: current_user,
                  form_embedded: form_embedded)
          end

          schema :id,
                 type: 'Integer'

          schema :created_at,
                 type: 'DateTime'

          schema :updated_at,
                 type: 'DateTime'

          schema :notification_message,
                 type: 'Formattable',
                 name_source: ->(*) { I18n.t(:label_message) },
                 writable: true,
                 required: false,
                 location: :meta

          schema_with_allowed_link :project,
                                   has_default: false,
                                   required: false,
                                   href_callback: ->(*) {
                                     allowed_projects_href
                                   }

          schema_with_allowed_link :principal,
                                   has_default: false,
                                   required: true,
                                   href_callback: ->(*) {
                                     allowed_principal_href
                                   }

          schema_with_allowed_link :roles,
                                   type: '[]Role',
                                   name_source: :role,
                                   has_default: false,
                                   required: true,
                                   href_callback: ->(*) {
                                     allowed_roles_href
                                   }

          def self.represented_class
            Member
          end

          def allowed_projects_href
            return unless represented.new_record?

            api_v3_paths.path_for(:memberships_available_projects, filters: allowed_projects_filters)
          end

          def allowed_projects_filters
            if represented.principal
              [{ principal: { operator: '!', values: [represented.principal.id.to_s] } }]
            end
          end

          def allowed_principal_href
            return unless represented.new_record?

            api_v3_paths.path_for(:principals, filters: allowed_principals_filters)
          end

          def allowed_principals_filters
            statuses = [Principal.statuses[:locked].to_s]
            status_filter = { status: { operator: '!', values: statuses } }

            filters = [status_filter]

            if represented.project
              member_filter = { member: { operator: '!', values: [represented.project.id.to_s] } }

              filters << member_filter
            end

            filters
          end

          def allowed_roles_href
            filters = represented.new_record? ? {} : { filters: allowed_roles_filters }

            api_v3_paths.path_for(:roles, **filters)
          end

          def allowed_roles_filters
            value = represented.project ? 'project' : 'system'

            [{ unit: { operator: '=', values: [value] } }]
          end
        end
      end
    end
  end
end
