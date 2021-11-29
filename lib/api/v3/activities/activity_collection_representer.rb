#-- encoding: UTF-8



module API
  module V3
    module Activities
      class ActivityCollectionRepresenter < ::API::Decorators::UnpaginatedCollection
        def initialize(models, self_link:, current_user:)
          super

          @represented = ::API::V3::Activities::ActivityEagerLoadingWrapper.wrap(represented)
        end
      end
    end
  end
end
