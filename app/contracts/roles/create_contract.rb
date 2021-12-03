module Roles
  class CreateContract < BaseContract
    attribute :type

    validate :type_in_allowed

    private

    def type_in_allowed
      unless [Role.name, GlobalRole.name].include?(model.type)
        errors.add(:type, :inclusion)
      end
    end
  end
end
