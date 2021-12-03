module API
  module Utilities
    module Endpoints
      class Show
        def default_instance_generator(model)
          ->(_params) do
            instance_variable_get("@#{model.name.demodulize.underscore}")
          end
        end

        def initialize(model:,
                       api_name: model.name.demodulize,
                       render_representer: nil,
                       instance_generator: default_instance_generator(model))

          self.model = model
          self.api_name = api_name
          self.instance_generator = instance_generator
          self.render_representer = render_representer || deduce_render_representer
        end

        def mount
          show = self

          -> do
            show.render(self)
          end
        end

        def render(request)
          render_representer
            .create(request.instance_exec(request.params, &instance_generator),
                    current_user: request.current_user,
                    embed_links: true)
        end

        def self_path
          api_name.underscore.pluralize
        end

        attr_accessor :model,
                      :api_name,
                      :instance_generator,
                      :render_representer

        private

        def deduce_render_representer
          raise NotImplementedError
        end

        def deduce_api_namespace
          api_name.pluralize
        end
      end
    end
  end
end
