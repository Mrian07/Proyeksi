

module Attachments
  class DeleteContract < ::DeleteContract
    delete_permission -> {
      model.deletable?(user)
    }
  end
end
