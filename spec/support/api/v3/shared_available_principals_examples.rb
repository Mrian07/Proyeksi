

require 'rack/test'

shared_examples_for 'available principals' do |principals|
  include API::V3::Utilities::PathHelper

  current_user do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:other_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:project) { FactoryBot.create(:project) }
  let(:group) do
    FactoryBot.create(:group,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:placeholder_user) do
    FactoryBot.create(:placeholder_user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:permissions) { [:view_work_packages] }

  shared_context "request available #{principals}" do
    before { get href }
  end

  describe 'response' do
    shared_examples_for "returns available #{principals}" do |total, count, klass|
      include_context "request available #{principals}"

      it_behaves_like 'API V3 collection response', total, count, klass
    end

    describe 'users' do
      context 'single user' do
        # The current user

        it_behaves_like "returns available #{principals}", 1, 1, 'User'
      end

      context 'multiple users' do
        before do
          other_user
          # and the current user
        end

        it_behaves_like "returns available #{principals}", 2, 2, 'User'
      end
    end

    describe 'groups' do
      let!(:users) { [group] }

      # current user and group
      it_behaves_like "returns available #{principals}", 2, 2, 'Group'
    end

    describe 'placeholder users' do
      let!(:users) { [placeholder_user] }

      # current user and placeholder user
      it_behaves_like "returns available #{principals}", 2, 2, 'PlaceholderUser'
    end
  end

  describe 'if not allowed' do
    include Rack::Test::Methods
    let(:permissions) { [] }
    before { get href }

    it_behaves_like 'unauthorized access'
  end
end
