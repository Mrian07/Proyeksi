#-- encoding: UTF-8

require 'rspec'

require 'spec_helper'
require_relative './eager_loading_mock_wrapper'

describe ::API::V3::WorkPackages::EagerLoading::CustomAction do
  let!(:work_package1) { FactoryBot.create(:work_package) }
  let!(:work_package2) { FactoryBot.create(:work_package) }
  let!(:user) do
    FactoryBot.create(:user,
                      member_in_project: work_package2.project,
                      member_through_role: role)
  end
  let!(:role) { FactoryBot.create(:role) }
  let!(:status_custom_action) do
    FactoryBot.create(:custom_action,
                      conditions: [CustomActions::Conditions::Status.new(work_package1.status_id.to_s)])
  end
  let!(:role_custom_action) do
    FactoryBot.create(:custom_action,
                      conditions: [CustomActions::Conditions::Role.new(role.id)])
  end

  before do
    login_as(user)
  end

  describe '.apply' do
    it 'preloads the correct custom_actions' do
      wrapped = EagerLoadingMockWrapper.wrap(described_class, [work_package1, work_package2])

      expect(work_package1)
        .not_to receive(:custom_actions)
      expect(work_package2)
        .not_to receive(:custom_actions)

      expect(wrapped.detect { |w| w.id == work_package1.id }.custom_actions(user))
        .to match_array [status_custom_action]

      expect(wrapped.detect { |w| w.id == work_package2.id }.custom_actions(user))
        .to match_array [role_custom_action]
    end
  end
end
