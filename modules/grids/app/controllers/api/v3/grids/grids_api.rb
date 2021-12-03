

module API
  module V3
    module Grids
      class GridsAPI < ::API::ProyeksiAppAPI
        resources :grids do
          helpers do
            include API::Utilities::PageSizeHelper
          end

          get do
            query = ParamsToQueryService
                    .new(::Grids::Grid, current_user, query_class: ::Grids::Query)
                    .call(params)

            if query.valid?
              GridCollectionRepresenter.new(query.results,
                                            self_link: api_v3_paths.grids,
                                            grid_scope: query.filter_scope,
                                            page: to_i_or_nil(params[:offset]),
                                            per_page: resolve_page_size(params[:pageSize]),
                                            current_user: current_user)
            else
              raise ::API::Errors::InvalidQuery.new(query.errors.full_messages)
            end
          end

          post &::API::V3::Utilities::Endpoints::Create.new(model: ::Grids::Grid).mount

          mount ::API::V3::Grids::CreateFormAPI
          mount ::API::V3::Grids::Schemas::GridSchemaAPI

          route_param :id, type: Integer, desc: 'Grid ID' do
            after_validation do
              @grid = ::Grids::Query
                      .new(user: current_user)
                      .results
                      .find(params['id'])
            end

            get do
              GridRepresenter.new(@grid,
                                  current_user: current_user)
            end

            mount ::API::V3::Attachments::AttachmentsByGridAPI

            # Hack to be able to use the Default* mount while having the permission check
            # not affecting the GET request
            namespace do
              after_validation do
                unless ::Grids::UpdateContract.new(@grid, current_user).edit_allowed?
                  raise ActiveRecord::RecordNotFound
                end
              end

              patch &::API::V3::Utilities::Endpoints::Update.new(model: ::Grids::Grid,
                                                                 params_modifier: ->(params) do
                                                                   params[:widgets]&.each do |widget|
                                                                     # Need to parse the widget options again
                                                                     # as the right representer needs to be used
                                                                     # which is specific to the @grid.class. The parsing
                                                                     # before strives to be agnostic.
                                                                     strategy = ::Grids::Configuration
                                                                                .widget_strategy(@grid.class,
                                                                                                 widget.identifier)
                                                                     representer = strategy.options_representer.constantize

                                                                     widget.options = representer
                                                                                      .new(OpenStruct.new, current_user: current_user)
                                                                                      .from_hash(widget.options)
                                                                                      .to_h
                                                                                      .with_indifferent_access
                                                                   end

                                                                   params
                                                                 end)
                                                            .mount
              delete &::API::V3::Utilities::Endpoints::Delete.new(model: ::Grids::Grid).mount

              mount ::API::V3::Grids::UpdateFormAPI
            end
          end
        end
      end
    end
  end
end
