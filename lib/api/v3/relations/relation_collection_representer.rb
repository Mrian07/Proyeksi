#-- encoding: UTF-8

module API
  module V3
    module Relations
      class RelationCollectionRepresenter < ::API::Decorators::UnpaginatedCollection
        self.to_eager_load = ::API::V3::Relations::RelationRepresenter.to_eager_load
      end
    end
  end
end
