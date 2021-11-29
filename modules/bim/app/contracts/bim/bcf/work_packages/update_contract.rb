#-- encoding: UTF-8



# The contract allows for setting the default status ignoring status transitions.
# It is required so that put requests can set the status to the default status if the status property
# is omitted.
module Bim::Bcf::WorkPackages
  class UpdateContract < ::WorkPackages::UpdateContract
    def self.model
      ::WorkPackage
    end

    private

    def validate_status_transition
      super if status_changed? && !model.status.is_default?
    end
  end
end
