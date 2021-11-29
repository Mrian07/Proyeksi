

module Bim::Bcf::API::V2_1
  module Viewpoints
    class API < ::API::OpenProjectAPI
      # Avoid oj parsing numbers into BigDecimal
      parser :json, ::API::Utilities::JsonGemParser

      resources :viewpoints do
        get do
          @issue
            .viewpoints
            .select(::Bim::Bcf::API::V2_1::Viewpoints::FullRepresenter.selector)
            .map(&:json_viewpoint)
        end

        post &::Bim::Bcf::API::V2_1::Endpoints::Create
                .new(model: Bim::Bcf::Viewpoint,
                     params_modifier: ->(attributes) {
                       {
                         json_viewpoint: attributes,
                         issue: @issue
                       }
                     })
                .mount

        route_param :viewpoint_uuid, regexp: /\A[a-f0-9\-]+\z/ do
          %i[/ selection coloring visibility].each do |key|
            namespace = key == :/ ? :Full : key.to_s.camelize

            get key, &::Bim::Bcf::API::V2_1::Endpoints::Show
                        .new(model: Bim::Bcf::Viewpoint,
                             render_representer: "::Bim::Bcf::API::V2_1::Viewpoints::#{namespace}Representer".constantize,
                             instance_generator: ->(*) { @issue.viewpoints.where(uuid: params[:viewpoint_uuid]) })
                        .mount
          end

          delete &::Bim::Bcf::API::V2_1::Endpoints::Delete
                    .new(model: Bim::Bcf::Viewpoint,
                         instance_generator: ->(*) { @issue.viewpoints.find_by!(uuid: params[:viewpoint_uuid]) })
                    .mount

          get :bitmaps do
            raise NotImplementedError, 'Bitmaps are not yet implemented.'
          end

          namespace :snapshot, &::API::Helpers::AttachmentRenderer.content_endpoint(&-> {
            snapshot = @issue.viewpoints.find_by!(uuid: params[:viewpoint_uuid]).snapshot

            snapshot || raise(ActiveRecord::RecordNotFound)
          })
        end
      end
    end
  end
end
