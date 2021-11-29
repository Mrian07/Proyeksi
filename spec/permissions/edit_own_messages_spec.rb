

require 'spec_helper'
require 'support/permission_specs'

describe MessagesController, 'edit_own_messages permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('messages#preview', :edit_own_messages)
end
