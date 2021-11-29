

require 'spec_helper'
require 'support/permission_specs'

describe MessagesController, 'add_messages permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('messages#preview', :add_messages)
end
