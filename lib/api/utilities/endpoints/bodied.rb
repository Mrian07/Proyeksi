

module API
  module Utilities
    module Endpoints
      class Bodied
        def default_instance_generator(_model)
          raise NotImplementedError
        end

        def default_params_modifier
          ->(params) do
            params
          end
        end

        def default_process_state
          ->(**) do
            {}
          end
        end

        def default_params_source
          ->(request) do
            request.request_body
          end
        end

        def initialize(model:,
                       api_name: model.name.demodulize,
                       instance_generator: default_instance_generator(model),
                       params_modifier: default_params_modifier,
                       params_source: default_params_source,
                       process_state: default_process_state,
                       before_hook: nil,
                       parse_representer: nil,
                       render_representer: nil,
                       process_service: nil,
                       process_contract: nil,
                       parse_service: nil)
          self.model = model
          self.api_name = api_name
          self.instance_generator = instance_generator
          self.params_modifier = params_modifier
          self.params_source = params_source
          self.process_state = process_state
          self.parse_representer = parse_representer || deduce_parse_representer
          self.render_representer = render_representer || deduce_render_representer
          self.process_contract = process_contract || deduce_process_contract
          self.process_service = process_service || deduce_process_service
          self.parse_service = parse_service || deduce_parse_service
          self.before_hook = before_hook
        end

        def mount
          update = self

          -> do
            update.before_hook&.(request: self)
            params = update.parse(self)
            call = update.process(self, params)

            update.render(self, call) do
              status update.success_status
            end
          end
        end

        def parse(request)
          parse_service
            .new(request.current_user,
                 model: model,
                 representer: parse_representer)
            .call(params_source.call(request))
            .result
        end

        def process(request, params)
          instance = request.instance_exec(params, &instance_generator)

          args = { user: request.current_user,
                   model: instance,
                   contract_class: process_contract }

          process_service
            .new(**args.compact)
            .with_state(request.instance_exec(**{ model: instance, params: params }, &process_state))
            .call(**request.instance_exec(params, &params_modifier))
        end

        def render(request, call)
          if success?(call)
            yield
            present_success(request, call)
          else
            present_error(call)
          end
        end

        def success_status
          :ok
        end

        attr_accessor :model,
                      :api_name,
                      :instance_generator,
                      :parse_representer,
                      :render_representer,
                      :params_source,
                      :params_modifier,
                      :process_contract,
                      :process_service,
                      :parse_service,
                      :process_state,
                      :before_hook

        private

        def present_success(_request, _call)
          raise NotImplementedError
        end

        def present_error(_call)
          raise NotImplementedError
        end

        def success?(call)
          call.success?
        end

        def deduce_process_service
          "::#{deduce_backend_namespace}::SetAttributesService".constantize
        end

        def deduce_process_contract
          "::#{deduce_backend_namespace}::#{update_or_create}Contract".constantize
        end

        def deduce_parse_representer
          raise NotImplementedError
        end

        def deduce_parse_service
          raise NotImplementedError
        end

        def deduce_render_representer
          raise NotImplementedError
        end

        def deduce_api_namespace
          api_name.pluralize
        end

        def backend_name
          model.name.demodulize
        end

        def deduce_backend_namespace
          backend_name.pluralize
        end

        def update_or_create
          raise NotImplementedError
        end
      end
    end
  end
end
