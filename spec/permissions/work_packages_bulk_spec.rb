

require 'spec_helper'
require_relative '../support/permission_specs'

describe WorkPackages::BulkController, 'edit_work_packages permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('work_packages/bulk#edit', :edit_work_packages)
  check_permission_required_for('work_packages/bulk#update', :edit_work_packages)
end
