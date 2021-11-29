

require 'spec_helper'

describe ::API::V3::Actions::ActionSqlRepresenter, 'rendering' do
  include ::API::V3::Utilities::PathHelper

  let(:scope) do
    Action
      .where(id: action_id)
      .limit(1)
  end
  let(:action_id) do
    'memberships/create'
  end
  current_user do
    FactoryBot.create(:user)
  end

  subject(:json) do
    ::API::V3::Utilities::SqlRepresenterWalker
      .new(scope,
           embed: {},
           select: { 'id' => {}, '_type' => {}, 'self' => {} },
           current_user: current_user)
      .walk(API::V3::Actions::ActionSqlRepresenter)
      .to_json
  end

  context 'with a project action' do
    it 'renders as expected' do
      expect(json)
        .to be_json_eql({
                          "id": action_id,
                          "_type": "Action",
                          "_links": {
                            "self": {
                              "href": api_v3_paths.action(action_id)
                            }
                          }
                        }.to_json)
    end
  end
end
