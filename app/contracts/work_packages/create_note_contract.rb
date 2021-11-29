#-- encoding: UTF-8



module WorkPackages
  class CreateNoteContract < ::ModelContract
    def self.model
      WorkPackage
    end

    attribute :journal_notes do
      errors.add(:journal_notes, :error_unauthorized) unless can?(:comment)
    end

    private

    def can?(permission)
      policy.allowed?(model, permission)
    end

    attr_writer :policy

    def policy
      @policy ||= WorkPackagePolicy.new(user)
    end
  end
end
