

require 'spec_helper'

describe Queries::WorkPackages::Filter::ProjectFilter, type: :model do
  let(:query) { FactoryBot.build :query }
  let(:instance) do
    described_class.create!(name: 'project', context: query, operator: '=', values: [])
  end

  describe '#allowed_values' do
    let!(:project) { FactoryBot.create :project }
    let!(:archived_project) { FactoryBot.create :project, active: false }

    let(:user) { FactoryBot.create(:user, member_in_projects: [project, archived_project], member_through_role: role) }
    let(:role) { FactoryBot.create :role, permissions: %i(view_work_packages) }

    before do
      login_as user
    end

    it 'does not include the archived project (Regression #36026)' do
      expect(instance.allowed_values)
        .to match_array [[project.name, project.id.to_s]]
    end
  end
end
