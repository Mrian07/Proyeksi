#-- encoding: UTF-8

require 'model_contract'

module Projects
  class DeleteContract < ::DeleteContract
    delete_permission :admin
  end
end
