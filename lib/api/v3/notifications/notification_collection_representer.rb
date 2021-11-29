#-- encoding: UTF-8



module API
  module V3
    module Notifications
      class NotificationCollectionRepresenter < ::API::Decorators::OffsetPaginatedCollection
        def initialize(models, self_link:, current_user:, query: {}, page: nil, per_page: nil, groups: nil)
          super

          @represented = ::API::V3::Notifications::NotificationEagerLoadingWrapper.wrap(represented)
        end
      end
    end
  end
end
