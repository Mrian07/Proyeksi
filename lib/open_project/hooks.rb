

##
# A placeholder module which contains OpenProject hooks
module OpenProject
  module Hooks; end
end

# actual hooks are added with the following require statemens
require 'open_project/hooks/view_account_login_auth_provider'
require 'open_project/hooks/view_account_login_bottom'
