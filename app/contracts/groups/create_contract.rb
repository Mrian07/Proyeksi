#-- encoding: UTF-8



module Groups
  class CreateContract < BaseContract
    attribute :type

    validate :type_is_group

    private

    def type_is_group
      unless model.type == Group.name
        errors.add(:type, 'Type and class mismatch')
      end
    end
  end
end
