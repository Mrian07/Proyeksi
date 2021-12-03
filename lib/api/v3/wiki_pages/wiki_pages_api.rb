

module API
  module V3
    module WikiPages
      class WikiPagesAPI < ::API::ProyeksiAppAPI
        resources :wiki_pages do
          helpers do
            def wiki_page
              WikiPage.visible(current_user).find(params[:id])
            end
          end

          route_param :id, type: Integer, desc: 'Wiki page ID' do
            get do
              ::API::V3::WikiPages::WikiPageRepresenter.new(wiki_page,
                                                            current_user: current_user,
                                                            embed_links: true)
            end

            mount ::API::V3::Attachments::AttachmentsByWikiPageAPI
          end
        end
      end
    end
  end
end
