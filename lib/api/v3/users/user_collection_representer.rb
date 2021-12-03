#-- encoding: UTF-8

module API
  module V3
    module Users
      class UserCollectionRepresenter < ::API::Decorators::UnpaginatedCollection
        include API::V3::Principals::NotBuiltinElements
      end
    end
  end
end
