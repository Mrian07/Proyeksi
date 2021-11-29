

module API
  module V3
    module Utilities
      module Endpoints
        class SqlShow
          def initialize(model:)

            self.model = model
          end

          def mount
            show = self

            -> do
              scope = show.scope(params)

              show.check_visibility(scope)
              show.render(scope)
            end
          end

          def scope(params)
            query_class.new(user: User.current)
                       .where('id', '=', params[:id])
                       .results
          end

          def check_visibility(scope)
            raise ::API::Errors::NotFound.new unless scope.exists?
          end

          def render(scope)
            ::API::V3::Utilities::SqlRepresenterWalker
              .new(scope.limit(1),
                   embed: {},
                   select: { '*' => {} },
                   current_user: User.current)
              .walk(render_representer)
          end

          attr_accessor :model,
                        :api_name

          private

          def render_representer
            "API::V3::#{model.name.pluralize}::#{model.name}SqlRepresenter".constantize
          end

          def query_class
            "Queries::#{model.name.pluralize}::#{model.name}Query".constantize
          end
        end
      end
    end
  end
end
