

require 'spec_helper'

describe ::API::Decorators::Single do
  let(:user) { FactoryBot.create(:user, member_in_project: project, member_through_role: role) }
  let(:project) { FactoryBot.create(:project_with_types) }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { [:view_work_packages] }
  let(:model) { Object.new }

  let(:single) { ::API::Decorators::Single.new(model, current_user: user) }

  it 'should authorize for a given permission' do
    expect(single.current_user_allowed_to(:view_work_packages, context: project)).to be_truthy
  end

  context 'unauthorized user' do
    let(:permissions) { [] }

    it 'should not authorize unauthorized user' do
      expect(single.current_user_allowed_to(:view_work_packages, context: project)).to be_falsey
    end
  end

  describe '.checked_permissions' do
    let(:permissions) { [:add_work_packages] }
    let!(:initial_value) { described_class.checked_permissions }

    it 'stores the value' do
      expect(described_class.checked_permissions).to be_nil

      described_class.checked_permissions = permissions

      expect(described_class.checked_permissions).to match_array permissions
    end

    after do
      described_class.checked_permissions = initial_value
    end
  end
end
