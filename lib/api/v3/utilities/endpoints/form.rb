

module API
  module V3
    module Utilities
      module Endpoints
        class Form < API::Utilities::Endpoints::Bodied
          include V3Deductions

          def success?(call)
            only_validation_errors?(api_errors(call))
          end

          def present_success(request, call)
            render_representer
              .new(call.result,
                   errors: api_errors(call),
                   meta: call.state,
                   current_user: request.current_user)
          end

          def present_error(call)
            fail ::API::Errors::MultipleErrors.create_if_many(api_errors(call))
          end

          def only_validation_errors?(errors)
            errors.all? { |error| error.code == 422 }
          end

          private

          def api_errors(call)
            ::API::Errors::ErrorBase.create_errors(call.errors)
          end

          def deduce_render_representer
            "::API::V3::#{deduce_api_namespace}::#{update_or_create}FormRepresenter".constantize
          end
        end
      end
    end
  end
end
