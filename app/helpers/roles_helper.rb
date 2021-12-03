#-- encoding: UTF-8

module RolesHelper
  def setable_permissions(role)
    # Use the base contract for now as we are only interested in the setable permissions
    # which do not differentiate.
    contract = Roles::BaseContract.new(role, current_user)

    contract.assignable_permissions
  end

  def grouped_setable_permissions(role)
    group_permissions_by_module(setable_permissions(role))
  end

  private

  def group_permissions_by_module(perms)
    perms_by_module = perms.group_by { |p| p.project_module.to_s }
    ::ProyeksiApp::AccessControl
      .sorted_module_names(false)
      .select { |module_name| perms_by_module[module_name].present? }
      .map do |module_name|
      [module_name, perms_by_module[module_name]]
    end
  end
end
