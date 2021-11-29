

require 'spec_helper'
require File.expand_path('../support/permission_specs', __dir__)

describe ForumsController, 'manage_forums permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('forums#create', :manage_forums)
  check_permission_required_for('forums#move', :manage_forums)
end
