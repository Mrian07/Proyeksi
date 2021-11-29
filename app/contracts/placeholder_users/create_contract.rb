#-- encoding: UTF-8



module PlaceholderUsers
  class CreateContract < BaseContract
    include RequiresEnterpriseGuard
    self.enterprise_action = :placeholder_users

    attribute :type

    validate :type_is_placeholder_user

    private

    def type_is_placeholder_user
      unless model.type == PlaceholderUser.name
        errors.add(:type, 'Type and class mismatch')
      end
    end
  end
end
