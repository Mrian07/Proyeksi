module API
  module Utilities
    module Endpoints
      class Create < Modify
        def default_instance_generator(_model)
          ->(_params) do
          end
        end

        def success_status
          :created
        end

        private

        def update_or_create
          "Create"
        end
      end
    end
  end
end
