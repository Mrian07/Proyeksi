

require 'spec_helper'

describe Member, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:role) { FactoryBot.create(:role) }
  let(:project) { FactoryBot.create(:project) }
  let(:member) { FactoryBot.create(:member, user: user, roles: [role]) }
  let(:new_member) { FactoryBot.build(:member, user: user, roles: [role], project: project) }

  describe '#project' do
    context 'with a project' do
      it 'is valid' do
        expect(new_member)
          .to be_valid
      end
    end

    context 'without a project (global)' do
      let(:project) { nil }

      it 'is valid' do
        expect(new_member)
          .to be_valid
      end
    end

    context 'without a project (global) but with a global membership already existing' do
      let(:project) { nil }
      let!(:existing_member) { FactoryBot.create(:member, user: user, roles: [role], project: project) }

      it 'is invalid' do
        expect(new_member)
          .to be_invalid
      end
    end
  end
end
