

require 'spec_helper'
require_relative '../support/permission_specs'

describe WorkPackages::BulkController, 'delete_work_packages permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('work_packages/bulk#destroy', :delete_work_packages)
end
