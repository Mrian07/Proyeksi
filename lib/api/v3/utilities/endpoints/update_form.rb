

module API
  module V3
    module Utilities
      module Endpoints
        class UpdateForm < Form
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
end
