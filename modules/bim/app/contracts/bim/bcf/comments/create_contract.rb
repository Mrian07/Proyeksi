

module Bim::Bcf
  module Comments
    class CreateContract < ::Bim::Bcf::Comments::BaseContract
      attribute :journal

      validate :validate_journal

      private

      def validate_journal
        errors.add(:base, :invalid) if model.journal.journable != model.issue.work_package
      end
    end
  end
end
