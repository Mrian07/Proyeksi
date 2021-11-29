

module API
  module V3
    module WorkPackages
      class WorkPackageRelationsAPI < ::API::OpenProjectAPI
        helpers ::API::V3::Relations::RelationsHelper

        resources :relations do
          ##
          # @todo Redirect to relations endpoint as soon as `list relations` API endpoint
          #       including filters is complete.
          get do
            query = ::Queries::Relations::RelationQuery.new(user: current_user)

            relations = query
                        .where(:involved, '=', @work_package.id)
                        .results
                        .non_hierarchy
                        .includes(::API::V3::Relations::RelationCollectionRepresenter.to_eager_load)

            ::API::V3::Relations::RelationCollectionRepresenter.new(
              relations,
              self_link: api_v3_paths.work_package_relations(@work_package.id),
              current_user: current_user
            )
          end

          post do
            rep = parse_representer.new Relation.new, current_user: current_user
            relation = rep.from_json request.body.read
            service = ::Relations::CreateService.new user: current_user
            call = service.call relation, send_notifications: (params[:notify] != 'false')

            if call.success?
              representer.new call.result, current_user: current_user, embed_links: true
            else
              fail ::API::Errors::ErrorBase.create_and_merge_errors(call.all_errors.reject(&:empty?).first)
            end
          end
        end
      end
    end
  end
end
