#-- encoding: UTF-8


module BasicData
  class BuiltinRolesSeeder < Seeder
    def seed_data!
      data.each do |attributes|
        unless Role.find_by(builtin: attributes[:builtin]).nil?
          puts "   *** Skipping built in role #{attributes[:name]} - already exists"
          next
        end

        Role.create(attributes)
      end
    end

    def data
      [
        { name: I18n.t(:default_role_non_member), position: 0, builtin: Role::BUILTIN_NON_MEMBER },
        { name: I18n.t(:default_role_anonymous),  position: 1, builtin: Role::BUILTIN_ANONYMOUS  }
      ]
    end
  end
end
