

class RbTasksController < RbApplicationController
  # This is a constant here because we will recruit it elsewhere to whitelist
  # attributes. This is necessary for now as we still directly use `attributes=`
  # in non-controller code.
  PERMITTED_PARAMS = ["id", "subject", "assigned_to_id", "remaining_hours", "parent_id",
                      "estimated_hours", "status_id", "sprint_id"]

  def create
    call = Tasks::CreateService
           .new(user: current_user)
           .call(attributes: task_params.merge(project: @project), prev: params[:prev])

    respond_with_task call
  end

  def update
    task = Task.find(task_params[:id])

    call = Tasks::UpdateService
           .new(user: current_user, task: task)
           .call(attributes: task_params, prev: params[:prev])

    respond_with_task call
  end

  private

  def respond_with_task(call)
    status = call.success? ? 200 : 400
    @task = call.result

    @include_meta = true

    respond_to do |format|
      format.html { render partial: 'task', object: @task, status: status, locals: { errors: call.errors } }
    end
  end

  def task_params
    params.permit(PERMITTED_PARAMS).to_h.symbolize_keys
  end
end
