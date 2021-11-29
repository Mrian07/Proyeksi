

module Bim::Bcf
  module Issues
    class CreateContract < BaseContract
      attribute :uuid
      attribute :work_package do
        errors.add(:work_package, :taken) if model&.work_package&.bcf_issue
      end
    end
  end
end
