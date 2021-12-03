module Members
  class DeleteContract < ::DeleteContract
    delete_permission :manage_members

    validate :member_is_deletable

    private

    def member_is_deletable
      errors.add(:base, :not_deletable) unless model.deletable?
    end
  end
end
