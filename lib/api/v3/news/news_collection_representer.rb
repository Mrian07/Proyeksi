#-- encoding: UTF-8

module API
  module V3
    module News
      class NewsCollectionRepresenter < ::API::Decorators::OffsetPaginatedCollection
      end
    end
  end
end
