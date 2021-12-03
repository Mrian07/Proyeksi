#-- encoding: UTF-8

class Roles::CreateService < ::BaseServices::Create
  include Roles::NotifyMixin

  private

  def perform(params)
    copy_workflow_id = params.delete(:copy_workflow_from)

    super_call = super

    if super_call.success?
      copy_workflows(copy_workflow_id, super_call.result)

      notify_changed_roles(:added, super_call.result)
    end

    super_call
  end

  def instance(params)
    if params.delete(:global_role)
      GlobalRole.new
    else
      super
    end
  end

  def copy_workflows(copy_workflow_id, role)
    if copy_workflow_id.present? && (copy_from = Role.find_by(id: copy_workflow_id))
      role.workflows.copy_from_role(copy_from)
    end
  end
end
