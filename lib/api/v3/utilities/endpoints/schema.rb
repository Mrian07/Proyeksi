module API
  module V3
    module Utilities
      module Endpoints
        class Schema
          def default_instance_generator(model)
            ->(_params) do
              model.new
            end
          end

          def initialize(model:,
                         api_name: model.name.demodulize,
                         render_representer: nil,
                         contract: nil,
                         instance_generator: default_instance_generator(model))
            self.model = model
            self.api_name = api_name
            self.instance_generator = instance_generator
            self.representer = render_representer || deduce_representer
            self.contract = contract || deduce_contract
          end

          def mount
            schema = self

            -> do
              schema.render(self)
            end
          end

          def render(request)
            instance = request.instance_exec(request.params, &instance_generator)

            representer
              .create(contract.new(instance, request.current_user),
                      self_link: request.api_v3_paths.send(self_path),
                      current_user: request.current_user)
          end

          def self_path
            "#{api_name.underscore}_schema"
          end

          attr_accessor :model,
                        :api_name,
                        :representer,
                        :contract,
                        :instance_generator

          private

          def deduce_representer
            "::API::V3::#{deduce_namespace}::Schemas::#{api_name}SchemaRepresenter".constantize
          end

          def deduce_contract
            "::#{deduce_namespace}::CreateContract".constantize
          end

          def deduce_namespace
            api_name.pluralize
          end
        end
      end
    end
  end
end
