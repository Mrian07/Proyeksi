module API
  module Utilities
    module Endpoints
      class Update < Modify
        def default_instance_generator(model)
          ->(_params) do
            instance_variable_get("@#{model.name.demodulize.underscore}")
          end
        end

        private

        def update_or_create
          "Update"
        end
      end
    end
  end
end
