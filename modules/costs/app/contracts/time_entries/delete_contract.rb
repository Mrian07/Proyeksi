#-- encoding: UTF-8



module TimeEntries
  class DeleteContract < ::DeleteContract
    delete_permission -> {
      edit_all = user.allowed_to?(:edit_time_entries, model.project)
      edit_own = user.allowed_to?(:edit_own_time_entries, model.project)

      if model.user == user
        edit_own || edit_all
      else
        edit_all
      end
    }
  end
end
