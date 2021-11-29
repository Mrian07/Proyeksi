#-- encoding: UTF-8



module Groups
  class DeleteContract < ::DeleteContract
    delete_permission -> { user.active? && user.admin? }
  end
end
