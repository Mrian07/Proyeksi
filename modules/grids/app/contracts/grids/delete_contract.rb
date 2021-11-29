#-- encoding: UTF-8



require 'grids/base_contract'

module Grids
  class DeleteContract < ::DeleteContract
    delete_permission -> { model.user_deletable? && Grids::Configuration.writable?(model, user) }
  end
end
