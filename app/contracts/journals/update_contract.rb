module Journals
  class UpdateContract < BaseContract
    attribute :notes

    validate :user_allowed_to_edit

    private

    def user_allowed_to_edit
      errors.add(:base, :error_unauthorized) unless model.editable_by?(user)
    end
  end
end
