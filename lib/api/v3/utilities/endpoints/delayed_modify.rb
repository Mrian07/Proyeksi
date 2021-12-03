module API
  module V3
    module Utilities
      module Endpoints
        class DelayedModify < API::Utilities::Endpoints::Modify
          include V3Deductions
          include ::API::V3::Utilities::PathHelper

          private

          def present_success(request, call)
            redirect_to_status(request, call.result)
          end

          def redirect_to_status(request, job)
            request.redirect api_v3_paths.job_status(job.job_id)
          end
        end
      end
    end
  end
end
