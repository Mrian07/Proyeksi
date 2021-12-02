

require 'spec_helper'

describe Authorization::UserGlobalRolesQuery do
  let(:user) { FactoryBot.build(:user) }
  let(:anonymous) { FactoryBot.build(:anonymous) }
  let(:project) { FactoryBot.build(:project, public: false) }
  let(:project2) { FactoryBot.build(:project, public: false) }
  let(:public_project) { FactoryBot.build(:project, public: true) }
  let(:role) { FactoryBot.build(:role) }
  let(:role2) { FactoryBot.build(:role) }
  let(:anonymous_role) { FactoryBot.build(:anonymous_role) }
  let(:non_member) { FactoryBot.build(:non_member) }
  let(:member) do
    FactoryBot.build(:member, project: project,
                              roles: [role],
                              principal: user)
  end
  let(:member2) do
    FactoryBot.build(:member, project: project2,
                              roles: [role2],
                              principal: user)
  end
  let(:global_permission) { ProyeksiApp::AccessControl.permissions.find { |p| p.global? } }
  let(:global_role) do
    FactoryBot.build(:global_role,
                     permissions: [global_permission.name])
  end
  let(:global_member) do
    FactoryBot.build(:global_member,
                     principal: user,
                     roles: [global_role])
  end

  describe '.query' do
    before do
      non_member.save!
      anonymous_role.save!
      user.save!
    end

    it 'is a user relation' do
      expect(described_class.query(user, project)).to be_a ActiveRecord::Relation
    end

    context 'w/ the user being a member in a project' do
      before do
        member.save!
      end

      it 'is the member and non member role' do
        expect(described_class.query(user)).to match_array [role, non_member]
      end
    end

    context 'w/ the user being a member in two projects' do
      before do
        member.save!
        member2.save!
      end

      it 'is both member and the non member role' do
        expect(described_class.query(user)).to match_array [role, role2, non_member]
      end
    end

    context 'w/o the user being a member in a project' do
      it 'is the non member role' do
        expect(described_class.query(user)).to match_array [non_member]
      end
    end

    context 'w/ the user being anonymous' do
      it 'is the anonymous role' do
        expect(described_class.query(anonymous)).to match_array [anonymous_role]
      end
    end

    context 'w/ the user having a global role' do
      before do
        global_member.save!
      end

      it 'is the global role and non member role' do
        expect(described_class.query(user)).to match_array [global_role, non_member]
      end
    end

    context 'w/ the user having a global role and a member role' do
      before do
        member.save!
        global_member.save!
      end

      it 'is the global role and non member role' do
        expect(described_class.query(user)).to match_array [global_role, role, non_member]
      end
    end
  end
end
