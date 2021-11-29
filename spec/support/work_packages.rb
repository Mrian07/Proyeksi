

def become_admin
  let(:current_user) { FactoryBot.create(:admin) }
end

def become_non_member(&block)
  let(:current_user) { FactoryBot.create(:user) }

  before do
    projects = block ? instance_eval(&block) : [project]

    projects.each do |p|
      current_user.memberships.select { |m| m.project_id == p.id }.each(&:destroy)
    end
  end
end

def become_member_with_permissions(permissions)
  let(:current_user) { FactoryBot.create(:user) }

  before do
    role = FactoryBot.create(:role, permissions: permissions)

    member = FactoryBot.build(:member, user: current_user, project: project)
    member.roles = [role]
    member.save!
  end
end

def become_member_with_view_planning_element_permissions
  become_member_with_permissions [:view_work_packages]
end

def become_member_with_move_work_package_permissions
  become_member_with_permissions [:move_work_packages]
end

def build_work_package_hierarchy(data, *attributes, parent: nil, shared_attributes: {})
  work_packages = []

  Array(data).each do |attr|
    if attr.is_a? Hash
      parent_wp = FactoryBot.create(
        :work_package, shared_attributes.merge(**attributes.zip(attr.keys.first).to_h)
      )

      work_packages << parent_wp
      work_packages += build_work_package_hierarchy(
        attr.values.first, *attributes, parent: parent_wp, shared_attributes: shared_attributes
      )
    else
      wp = FactoryBot.create :work_package, shared_attributes.merge(**attributes.zip(attr).to_h)

      parent.children << wp if parent

      work_packages << wp
    end
  end

  work_packages
end
