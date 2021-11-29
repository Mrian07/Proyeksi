

require 'spec_helper'

describe Authorization::UserProjectRolesQuery do
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

  describe '.query' do
    before do
      non_member.save!
      anonymous_role.save!
      user.save!
    end

    it 'is a user relation' do
      expect(described_class.query(user, project)).to be_a ActiveRecord::Relation
    end

    context 'w/ the user being a member in the project' do
      before do
        member.save!
      end

      it 'is the project roles' do
        expect(described_class.query(user, project)).to match [role]
      end
    end

    context 'w/o the user being member in the project
             w/ the project being private' do
      it 'is empty' do
        expect(described_class.query(user, project)).to be_empty
      end
    end

    context 'w/o the user being member in the project
             w/ the project being public' do
      it 'is the non member role' do
        expect(described_class.query(user, public_project)).to match_array [non_member]
      end
    end

    context 'w/ the user being anonymous
             w/ the project being public' do
      it 'is empty' do
        expect(described_class.query(anonymous, public_project)).to match_array [anonymous_role]
      end
    end

    context 'w/ the user being anonymous
             w/o the project being public' do
      it 'is empty' do
        expect(described_class.query(anonymous, project)).to be_empty
      end
    end

    context 'w/ the user being a member in two projects' do
      before do
        member.save!
        member2.save!
      end

      it 'returns only the roles from the requested project' do
        expect(described_class.query(user, project)).to match_array [role]
      end
    end
  end
end
