

module API
  module V3
    module TimeEntries
      module AvailableWorkPackagesHelper
        def available_work_packages_collection(allowed_scope)
          service = WorkPackageCollectionFromQueryParamsService
                      .new(current_user, scope: allowed_scope)
                      .call(params)

          if service.success?
            service.result
          else
            api_errors = service.errors.full_messages.map do |message|
              ::API::Errors::InvalidQuery.new(message)
            end

            raise ::API::Errors::MultipleErrors.create_if_many api_errors
          end
        end
      end
    end
  end
end
