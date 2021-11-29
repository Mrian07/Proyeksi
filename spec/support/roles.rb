

shared_context 'with non-member permissions from non_member_permissions' do
  around do |example|
    non_member = Role.non_member
    previous_permissions = non_member.permissions

    non_member.update_attribute(:permissions, non_member_permissions)
    example.run
    non_member.update_attribute(:permissions, previous_permissions)
  end
end
