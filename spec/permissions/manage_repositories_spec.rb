

require 'spec_helper'
require File.expand_path('../support/permission_specs', __dir__)

describe RepositoriesController, 'manage_repository permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('repositories#edit', :manage_repository)
end
