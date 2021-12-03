#-- encoding: UTF-8

module API
  module V3
    module Notifications
      class NotificationRepresenter < ::API::Decorators::Single
        include API::Decorators::DateProperty
        include API::Decorators::LinkedResource
        extend API::Decorators::PolymorphicResource

        self_link title_getter: ->(*) { represented.subject }

        property :id
        property :subject

        property :read_ian,
                 as: :readIAN

        property :reason

        date_time_property :created_at

        date_time_property :updated_at

        link :readIAN do
          next if represented.read_ian

          {
            href: api_v3_paths.notification_read_ian(represented.id),
            method: :post
          }
        end

        link :unreadIAN do
          next unless represented.read_ian

          {
            href: api_v3_paths.notification_unread_ian(represented.id),
            method: :post
          }
        end

        associated_resource :actor,
                            representer: ::API::V3::Users::UserRepresenter,
                            skip_render: ->(*) { represented.actor.nil? },
                            v3_path: :user

        associated_resource :project

        associated_resource :journal,
                            as: :activity,
                            representer: ::API::V3::Activities::ActivityRepresenter,
                            v3_path: :activity,
                            skip_render: ->(*) { represented.journal_id.nil? }

        polymorphic_resource :resource

        def _type
          'Notification'
        end

        self.to_eager_load = %i[project actor]
      end
    end
  end
end
