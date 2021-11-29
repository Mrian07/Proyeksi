#-- encoding: UTF-8



module API
  module V3
    module Grids
      class GridCollectionRepresenter < ::API::Decorators::OffsetPaginatedCollection
        attr_reader :grid_scope, :grid_writable

        def initialize(models, self_link:, grid_scope:, **args)
          super(models, self_link: self_link, **args)
          @grid_scope = grid_scope
          @grid_writable = ::Grids::Configuration.writable_scope?(grid_scope)
        end

        link :create do
          next unless grid_writable

          {
            href: api_v3_paths.create_grid_form,
            method: :post
          }
        end

        link :createImmediately do
          next unless grid_writable

          {
            href: api_v3_paths.grids,
            method: :post
          }
        end
      end
    end
  end
end
