#-- encoding: UTF-8



module API
  module V3
    module Projects
      module Statuses
        class StatusRepresenter < ::API::Decorators::Single
          link :self do
            {
              href: api_v3_paths.project_status(represented),
              title: I18n.t(:"activerecord.attributes.projects/status.codes.#{represented}")
            }
          end

          property :id,
                   getter: ->(*) { self }

          property :name,
                   getter: ->(*) { I18n.t(:"activerecord.attributes.projects/status.codes.#{self}") }

          def _type
            'ProjectStatus'
          end
        end
      end
    end
  end
end
