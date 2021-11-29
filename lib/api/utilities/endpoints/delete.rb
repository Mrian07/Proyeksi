

module API
  module Utilities
    module Endpoints
      class Delete
        def default_instance_generator(model)
          ->(_params) do
            instance_variable_get("@#{model.name.demodulize.underscore}")
          end
        end

        def initialize(model:,
                       instance_generator: default_instance_generator(model),
                       process_service: nil,
                       success_status: 204,
                       api_name: model.name.demodulize)
          self.model = model
          self.instance_generator = instance_generator
          self.process_service = process_service || deduce_process_service
          self.api_name = api_name
          self.success_status = success_status
        end

        def mount
          delete = self

          -> do
            call = delete.process(self)

            delete.render(call) do
              status delete.success_status
            end
          end
        end

        def process(request)
          process_service
            .new(user: request.current_user,
                 model: request.instance_exec(request.params, &instance_generator))
            .call
        end

        def render(call)
          if success?(call)
            yield
            present_success(call)
          else
            present_error(call)
          end
        end

        attr_accessor :model,
                      :instance_generator,
                      :process_service,
                      :api_name,
                      :success_status

        private

        def present_error(call)
          fail ::API::Errors::ErrorBase.create_and_merge_errors(call.errors)
        end

        def present_success(call)
          # Handle success cases by subclasses
        end

        def success?(call)
          call.success?
        end

        def deduce_process_service
          "::#{deduce_backend_namespace}::DeleteService".constantize
        end

        def deduce_backend_namespace
          demodulized_name.pluralize
        end

        def demodulized_name
          model.name.demodulize
        end

        def deduce_api_namespace
          api_name.pluralize
        end
      end
    end
  end
end
