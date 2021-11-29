

require 'spec_helper'
require 'rack/test'

describe 'API v3 Revisions resource', type: :request do
  include Rack::Test::Methods
  include Capybara::RSpecMatchers
  include API::V3::Utilities::PathHelper

  let(:revision) do
    FactoryBot.create(:changeset,
                      repository: repository,
                      comments: 'Some commit message',
                      committer: 'foo bar <foo@example.org>')
  end
  let(:repository) do
    FactoryBot.create(:repository_subversion, project: project)
  end
  let(:project) do
    FactoryBot.create(:project, identifier: 'test_project', public: false)
  end
  let(:role) do
    FactoryBot.create(:role,
                      permissions: [:view_changesets])
  end
  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end

  let(:unauthorized_user) { FactoryBot.create(:user) }

  describe '#get' do
    let(:get_path) { api_v3_paths.revision revision.id }

    context 'when acting as a user with permission to view revisions' do
      before(:each) do
        allow(User).to receive(:current).and_return current_user
        get get_path
      end

      it 'should respond with 200' do
        expect(last_response.status).to eq(200)
      end

      describe 'response body' do
        subject(:response) { last_response.body }

        it 'should respond with revision in HAL+JSON format' do
          is_expected.to be_json_eql(revision.id.to_json).at_path('id')
        end
      end

      context 'requesting nonexistent revision' do
        let(:get_path) { api_v3_paths.revision 909090 }

        it_behaves_like 'not found'
      end
    end

    context 'when acting as an user without permission to view work package' do
      before(:each) do
        allow(User).to receive(:current).and_return unauthorized_user
        get get_path
      end

      it_behaves_like 'not found'
    end
  end
end
