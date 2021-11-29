

require 'digest'

FactoryBot.define do
  factory :role do
    permissions { [] }
    sequence(:name) { |n| "role_#{n}" }
    assignable { true }

    factory :non_member do
      name { 'Non member' }
      builtin { Role::BUILTIN_NON_MEMBER }
      assignable { false }
      initialize_with { Role.where(name: name).first_or_initialize }
    end

    factory :anonymous_role do
      name { 'Anonymous' }
      builtin { Role::BUILTIN_ANONYMOUS }
      assignable { false }
      initialize_with { Role.where(name: name).first_or_initialize }
    end

    factory :existing_role do
      name { 'Role ' + Digest::MD5.hexdigest(permissions.map(&:to_s).join('/'))[0..4] }
      assignable { true }
      permissions { [] }

      initialize_with do
        role =
          if Role.where(name: name).exists?
            Role.find_by(name: name)
          else
            Role.create name: name, assignable: assignable
          end

        role.add_permission!(*permissions.reject { |p| role.permissions.include?(p) })

        role
      end
    end
  end
end
