module API
  module V3
    module Utilities
      module Endpoints
        class Update < API::Utilities::Endpoints::Update
          include V3Deductions
          include V3PresentSingle
        end
      end
    end
  end
end
