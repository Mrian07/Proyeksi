

require 'spec_helper'
require 'support/permission_specs'

describe TeamPlanner::TeamPlannerController, 'view_team_planner permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('team_planner/team_planner#index', :view_team_planner)
end
