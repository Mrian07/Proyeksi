

require 'spec_helper'
require File.expand_path('../support/permission_specs', __dir__)

describe WorkPackagesController, 'export_work_packages permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('work_packages#index', :export_work_packages)
  check_permission_required_for('work_packages#all', :export_work_packages)
end
