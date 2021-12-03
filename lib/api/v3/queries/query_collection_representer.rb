#-- encoding: UTF-8

module API
  module V3
    module Queries
      class QueryCollectionRepresenter < ::API::Decorators::UnpaginatedCollection
        def initialize(models, self_link:, current_user:)
          super(models.includes(::API::V3::Queries::QueryRepresenter.to_eager_load),
                self_link: self_link,
                current_user: current_user)
        end

        collection :elements,
                   getter: ->(*) {
                     represented.each(&:valid_subset!).map do |model|
                       element_decorator.create(model, current_user: current_user)
                     end
                   },
                   exec_context: :decorator,
                   embedded: true
      end
    end
  end
end
