

require 'spec_helper'
require 'support/permission_specs'

describe WikiController, 'edit_wiki_pages permission', type: :controller do
  include PermissionSpecs

  check_permission_required_for('wiki#preview', :edit_wiki_pages)
end
