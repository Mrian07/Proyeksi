#-- encoding: UTF-8



require 'spec_helper'

describe Principals::Scopes::Visible, type: :model do
  describe '.visible' do
    shared_let(:project) { FactoryBot.create :project }
    shared_let(:other_project) { FactoryBot.create :project }
    shared_let(:role) { FactoryBot.create :role, permissions: %i[manage_members] }

    shared_let(:other_project_user) { FactoryBot.create :user, member_in_project: other_project, member_through_role: role }
    shared_let(:global_user) { FactoryBot.create :user }

    subject { ::Principal.visible.to_a }

    context 'when user has manage_members permission' do
      current_user { FactoryBot.create :user, member_in_project: project, member_through_role: role }

      it 'sees all users' do
        expect(subject).to match_array [current_user, other_project_user, global_user]
      end
    end

    context 'when user has no manage_members permission, but it is in other project' do
      current_user { FactoryBot.create :user, member_in_project: other_project, member_with_permissions: %i[view_work_packages] }

      it 'sees the other user in the same project' do
        expect(subject).to match_array [current_user, other_project_user]
      end
    end

    context 'when user has no permission' do
      current_user { FactoryBot.create :user }

      it 'sees only herself' do
        expect(subject).to match_array [current_user]
      end
    end
  end
end
