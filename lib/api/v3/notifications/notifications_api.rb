module API
  module V3
    module Notifications
      class NotificationsAPI < ::API::ProyeksiAppAPI
        resources :notifications do
          after_validation do
            authorize_by_with_raise current_user.logged?
          end

          helpers do
            def notification_query
              @notification_query ||= ParamsToQueryService
                                        .new(Notification, current_user)
                                        .call(params)
            end

            def notification_scope
              ::Notification
                .visible(current_user)
                .includes(NotificationRepresenter.to_eager_load)
                .where
                .not(read_ian: nil)
            end

            def bulk_update_status(attributes)
              if notification_query.valid?
                notification_query.results.update_all({ updated_at: Time.zone.now }.merge(attributes))
                status 204
              else
                raise ::API::Errors::InvalidQuery.new(notification_query.errors.full_messages)
              end
            end
          end

          get &::API::V3::Utilities::Endpoints::Index
                 .new(model: Notification, scope: -> { notification_scope })
                 .mount

          post :read_ian do
            bulk_update_status(read_ian: true)
          end

          post :unread_ian do
            bulk_update_status(read_ian: false)
          end

          route_param :id, type: Integer, desc: 'Notification ID' do
            after_validation do
              @notification = notification_scope.find(params[:id])
            end

            helpers do
              def update_status(attributes)
                @notification.update_columns({ updated_at: Time.zone.now }.merge(attributes))
                status 204
              end
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: Notification).mount

            post :read_ian do
              update_status(read_ian: true)
            end

            post :unread_ian do
              update_status(read_ian: false)
            end
          end
        end
      end
    end
  end
end
