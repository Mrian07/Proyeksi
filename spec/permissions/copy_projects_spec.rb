

require 'spec_helper'
require File.expand_path('../support/permission_specs', __dir__)

describe ProjectsController, 'copy_projects permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('projects#copy', :copy_projects)
end
