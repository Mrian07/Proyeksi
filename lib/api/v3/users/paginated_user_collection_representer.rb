#-- encoding: UTF-8



# TODO: this is to be removed or rather the UserCollectionRepresenter is
# to be turned into an OffsetPaginatedCollection representer.
# It is not possible to do that right now as we do not have a
# solution for an accessible autocompleter drop down widget. We therefore
# have to fetch all users when we want to present them inside of a drop down.

module API
  module V3
    module Users
      class PaginatedUserCollectionRepresenter < ::API::Decorators::OffsetPaginatedCollection
        include API::V3::Principals::NotBuiltinElements
      end
    end
  end
end
