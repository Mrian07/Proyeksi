module API
  module V3
    module Utilities
      module Endpoints
        class CreateForm < Form
          def default_instance_generator(model)
            ->(_params) do
              model.new
            end
          end

          private

          def update_or_create
            "Create"
          end
        end
      end
    end
  end
end
