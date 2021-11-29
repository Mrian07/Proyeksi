

require 'spec_helper'
require 'support/permission_specs'

describe NewsController, 'manage_news permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('news#preview', :manage_news)
end
