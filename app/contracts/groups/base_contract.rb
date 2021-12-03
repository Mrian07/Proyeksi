module Groups
  class BaseContract < ::ModelContract
    include RequiresAdminGuard

    # attribute_alias is broken in the sense
    # that `model#changed` includes only the non-aliased name
    # hence we need to put "lastname" as an attribute here
    attribute :name
    attribute :lastname

    validate :validate_unique_users

    private

    # Validating on the group_users since those are dealt with in the
    # corresponding services.
    def validate_unique_users
      user_ids = model.group_users.map(&:user_id)

      if user_ids.uniq.length < user_ids.length
        errors.add(:group_users, :taken)
      end
    end
  end
end
