

require 'spec_helper'
require 'rack/test'

require_relative './shared_responses'

describe 'BCF 2.1 project extensions resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  shared_let(:type_task) { FactoryBot.create :type_task }
  shared_let(:status) { FactoryBot.create :default_status }
  shared_let(:priority) { FactoryBot.create :default_priority }
  shared_let(:project) { FactoryBot.create(:project, enabled_module_names: [:bim], types: [type_task]) }
  subject(:response) { last_response }

  let(:path) { "/api/bcf/2.1/projects/#{project.id}/extensions" }

  context 'with only view_project permissions' do
    let(:current_user) do
      FactoryBot.create(:user,
                        member_in_project: project,
                        member_with_permissions: [:view_project])
    end

    before do
      login_as(current_user)
      get path
    end

    it_behaves_like 'bcf api successful response' do
      let(:expected_body) do
        {
          topic_type: [],
          topic_status: [],
          priority: [],
          snippet_type: [],
          stage: [],
          topic_label: [],
          user_id_type: [],
          project_actions: [],
          topic_actions: [],
          comment_actions: []
        }
      end
    end
  end

  context 'with edit permissions in project' do
    let(:current_user) do
      FactoryBot.create(:user,
                        member_in_project: project,
                        member_with_permissions: %i[view_project edit_project manage_bcf view_members])
    end

    let(:other_user) do
      FactoryBot.create(:user,
                        member_in_project: project,
                        member_with_permissions: [:view_project])
    end

    before do
      other_user
      login_as(current_user)
      get path
    end

    it_behaves_like 'bcf api successful response expectation' do
      let(:expectations) do
        ->(body) {
          hash = JSON.parse(body)

          expect(hash.keys).to match_array %w[
            topic_type topic_status user_id_type project_actions topic_actions comment_actions
            stage snippet_type priority topic_label
          ]

          expect(hash['topic_type']).to include type_task.name
          expect(hash['topic_status']).to include status.name

          expect(hash['user_id_type']).to include(other_user.mail, current_user.mail)

          expect(hash['project_actions']).to eq %w[update viewTopic createTopic]

          expect(hash['topic_actions']).to eq %w[update updateRelatedTopics updateFiles createViewpoint]
          expect(hash['comment_actions']).to eq []
        }
      end
    end
  end
end
