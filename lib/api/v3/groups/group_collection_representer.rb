#-- encoding: UTF-8



module API
  module V3
    module Groups
      class GroupCollectionRepresenter < ::API::Decorators::OffsetPaginatedCollection
        element_decorator ::API::V3::Groups::GroupRepresenter
      end
    end
  end
end
