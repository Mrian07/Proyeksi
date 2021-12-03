

module Bim::Bcf::API::V2_1
  module Comments
    class API < ::API::ProyeksiAppAPI
      resources :comments do
        helpers do
          def all_comments
            @issue.comments.includes(:journal, :issue, :viewpoint)
          end

          def get_viewpoint_by_uuid(viewpoint_uuid)
            if viewpoint_uuid == nil
              nil
            else
              @issue.viewpoints.find_by(uuid: viewpoint_uuid) || ::Bim::Bcf::NonExistentViewpoint.new
            end
          end

          def get_comment_by_uuid(comment)
            if comment == nil
              nil
            else
              @issue.comments.find_by(uuid: comment) || ::Bim::Bcf::NonExistentComment.new
            end
          end

          def transform_create_parameter(params)
            {
              issue: @issue,
              viewpoint: get_viewpoint_by_uuid(params[:viewpoint_guid]),
              reply_to: get_comment_by_uuid(params[:reply_to_comment_guid])
            }
          end

          def transform_update_parameter(params)
            {
              original_comment: @comment,
              viewpoint: get_viewpoint_by_uuid(params[:viewpoint_guid]),
              reply_to: get_comment_by_uuid(params[:reply_to_comment_guid])
            }
          end
        end

        get &::Bim::Bcf::API::V2_1::Endpoints::Index.new(model: Bim::Bcf::Comment, scope: -> { all_comments }).mount

        post &::Bim::Bcf::API::V2_1::Endpoints::Create
                .new(model: Bim::Bcf::Comment,
                     params_modifier: ->(params) { transform_create_parameter(params).merge(params) })
                .mount

        params do
          requires :comment_guid, type: String, desc: 'The comment\'s UUID'
        end

        route_param :comment_guid, regexp: /\A[a-f0-9\-]+\z/ do
          after_validation do
            @comment = all_comments.find_by!(uuid: declared_params[:comment_guid])
          end

          get &::Bim::Bcf::API::V2_1::Endpoints::Show.new(model: Bim::Bcf::Comment).mount

          put &::Bim::Bcf::API::V2_1::Endpoints::Update
                 .new(model: Bim::Bcf::Comment,
                      params_modifier: ->(params) { transform_update_parameter(params).merge(params) })
                 .mount
        end
      end
    end
  end
end
