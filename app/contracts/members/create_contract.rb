

module Members
  class CreateContract < BaseContract
    include AssignableValuesContract

    attribute :project
    attribute :user_id
    attribute :principal do
      principal_assignable
    end

    def assignable_principals
      Principal.possible_member(project)
    end

    private

    def principal_assignable
      return if principal.nil?

      if principal.builtin? || principal.locked?
        errors.add(:principal, :unassignable)
      end
    end
  end
end
