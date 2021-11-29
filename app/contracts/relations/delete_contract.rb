#-- encoding: UTF-8



module Relations
  class DeleteContract < ::DeleteContract
    delete_permission -> {
      user.allowed_to? :manage_work_package_relations, model.from.project
    }
  end
end
