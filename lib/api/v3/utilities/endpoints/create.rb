module API
  module V3
    module Utilities
      module Endpoints
        class Create < API::Utilities::Endpoints::Create
          include V3Deductions
          include V3PresentSingle
        end
      end
    end
  end
end
