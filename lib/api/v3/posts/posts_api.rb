

module API
  module V3
    module Posts
      class PostsAPI < ::API::OpenProjectAPI
        resources :posts do
          helpers do
            def post
              Message.visible(current_user).find(params[:id])
            end
          end

          route_param :id, type: Integer, desc: 'Message ID' do
            get do
              ::API::V3::Posts::PostRepresenter.new(post,
                                                    current_user: current_user,
                                                    embed_links: true)
            end

            mount ::API::V3::Attachments::AttachmentsByPostAPI
          end
        end
      end
    end
  end
end
