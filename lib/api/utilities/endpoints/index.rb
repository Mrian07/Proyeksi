module API
  module Utilities
    module Endpoints
      class Index
        include ::API::Utilities::PageSizeHelper

        def initialize(model:,
                       api_name: model.name.demodulize,
                       scope: nil,
                       render_representer: nil)
          self.model = model_class(model)
          self.scope = scope
          self.api_name = api_name
          self.render_representer = render_representer || deduce_render_representer
        end

        def mount
          raise NotImplementedError
        end

        attr_accessor :model,
                      :api_name,
                      :scope,
                      :render_representer

        private

        def deduce_render_representer
          raise NotImplementedError
        end

        def deduce_api_namespace
          api_name.pluralize
        end

        def model_class(scope)
          if scope.is_a? Class
            scope
          else
            scope.model
          end
        end
      end
    end
  end
end
