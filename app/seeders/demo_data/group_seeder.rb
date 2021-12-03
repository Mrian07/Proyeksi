#-- encoding: UTF-8

module DemoData
  class GroupSeeder < Seeder
    attr_accessor :user

    include ::DemoData::References

    def initialize
      self.user = User.admin.first
    end

    def seed_data!
      print_status '    ↳ Creating groups' do
        seed_groups
      end
    end

    def applicable?
      Group.count.zero?
    end

    def add_projects_to_groups
      groups = demo_data_for('groups')
      if groups.present?
        groups.each do |group_attr|
          if group_attr[:projects].present?
            group = Group.find_by(lastname: group_attr[:name])
            group_attr[:projects].each do |project_attr|
              project = Project.find(project_attr[:name])
              role = Role.find_by(name: project_attr[:role])

              Member.create!(
                project: project,
                principal: group,
                roles: [role]
              )
            end
          end
        end
      end
    end

    private

    def seed_groups
      groups = demo_data_for('groups')
      if groups.present?
        groups.each do |group_attr|
          print_status '.'
          create_group group_attr[:name]
        end
      end
    end

    def create_group(name)
      Group.create lastname: name
    end
  end
end
