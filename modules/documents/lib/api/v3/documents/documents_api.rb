

module API
  module V3
    module Documents
      class DocumentsAPI < ::API::OpenProjectAPI
        helpers ::API::Utilities::PageSizeHelper

        resources :documents do
          get do
            query = ParamsToQueryService
                    .new(Document, current_user)
                    .call(params)

            if query.valid?
              DocumentCollectionRepresenter.new(query.results,
                                                self_link: api_v3_paths.documents,
                                                page: to_i_or_nil(params[:offset]),
                                                per_page: resolve_page_size(params[:pageSize]),
                                                current_user: current_user)
            else
              raise ::API::Errors::InvalidQuery.new(query.errors.full_messages)
            end
          end

          route_param :id, type: Integer, desc: 'Document ID' do
            helpers do
              def document
                Document.visible.find(params[:id])
              end
            end

            get do
              ::API::V3::Documents::DocumentRepresenter.new(document,
                                                            current_user: current_user,
                                                            embed_links: true)
            end

            mount ::API::V3::Attachments::AttachmentsByDocumentAPI
          end
        end
      end
    end
  end
end
