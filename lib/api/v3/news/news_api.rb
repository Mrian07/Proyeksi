

module API
  module V3
    module News
      class NewsAPI < ::API::OpenProjectAPI
        helpers ::API::Utilities::PageSizeHelper

        resources :news do
          get do
            query = ParamsToQueryService
                    .new(::News, current_user)
                    .call(params)

            if query.valid?
              NewsCollectionRepresenter.new(query.results,
                                            self_link: api_v3_paths.newses,
                                            page: to_i_or_nil(params[:offset]),
                                            per_page: resolve_page_size(params[:pageSize]),
                                            current_user: current_user)
            else
              raise ::API::Errors::InvalidQuery.new(query.errors.full_messages)
            end
          end

          route_param :id, type: Integer, desc: 'News ID' do
            after_validation do
              @news = ::News
                      .visible
                      .find(params[:id])
            end

            get do
              NewsRepresenter.create(@news,
                                     current_user: current_user,
                                     embed_links: true)
            end
          end
        end
      end
    end
  end
end
