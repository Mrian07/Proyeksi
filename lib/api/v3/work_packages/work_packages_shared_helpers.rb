

module API
  module V3
    module WorkPackages
      module WorkPackagesSharedHelpers
        extend Grape::API::Helpers

        def notify_according_to_params
          params[:notify] != 'false'
        end
      end
    end
  end
end
