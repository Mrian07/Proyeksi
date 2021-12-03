#-- encoding: UTF-8

module API
  module V3
    module Notifications
      class NotificationEagerLoadingWrapper < API::V3::Utilities::EagerLoading::EagerLoadingWrapper
        class << self
          def wrap(notifications)
            API::V3::Activities::ActivityEagerLoadingWrapper.wrap(notifications.map(&:journal))
            set_resource(notifications)

            super
          end

          private

          # Copy the resource over from the journal.
          # Those two should always be the same.
          # The journable will be loaded within the ActivityEagerLoadingWrapper.
          def set_resource(notifications)
            notifications.select { |n| n.journal.present? }.each do |notification|
              notification.resource = notification.journal.journable
            end
          end
        end
      end
    end
  end
end
