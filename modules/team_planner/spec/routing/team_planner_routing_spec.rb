

require 'spec_helper'

describe 'Team planner routing', type: :routing do
  it 'routes to team_planner#index' do
    expect(subject)
      .to route(:get, '/projects/foobar/team_planner/state')
      .to(controller: 'team_planner/team_planner', action: 'index', project_id: 'foobar', state: 'state')
  end
end
