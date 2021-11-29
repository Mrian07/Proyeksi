

class RbImpedimentsController < RbApplicationController
  def create
    call = Impediments::CreateService
           .new(user: current_user)
           .call(attributes: impediment_params(Impediment.new).merge(project: @project))

    respond_with_impediment call
  end

  def update
    @impediment = Impediment.find(params[:id])

    call = Impediments::UpdateService
           .new(user: current_user, impediment: @impediment)
           .call(attributes: impediment_params(@impediment))

    respond_with_impediment call
  end

  private

  def respond_with_impediment(call)
    status = call.success? ? 200 : 400
    @impediment = call.result

    @include_meta = true

    respond_to do |format|
      format.html { render partial: 'impediment', object: @impediment, status: status, locals: { errors: call.errors } }
    end
  end

  def impediment_params(instance)
    # We do not need project_id, since ApplicationController will take care of
    # fetching the record.
    params.delete(:project_id)

    hash = params
           .permit(:version_id, :status_id, :id, :sprint_id,
                   :assigned_to_id, :remaining_hours, :subject, :blocks_ids)
           .to_h
           .symbolize_keys

    # We block block_ids only when user is not allowed to create or update the
    # instance passed.
    unless instance && ((instance.new_record? && User.current.allowed_to?(:add_work_packages,
                                                                          @project)) || User.current.allowed_to?(
                                                                            :edit_work_packages, @project
                                                                          ))
      hash.delete(:block_ids)
    end

    hash
  end
end
