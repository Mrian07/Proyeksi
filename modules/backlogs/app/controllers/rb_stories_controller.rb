

class RbStoriesController < RbApplicationController
  include ProyeksiApp::PDFExport::ExportCard

  # This is a constant here because we will recruit it elsewhere to whitelist
  # attributes. This is necessary for now as we still directly use `attributes=`
  # in non-controller code.
  PERMITTED_PARAMS = %i[id status_id version_id
                        story_points type_id subject author_id
                        sprint_id]

  def create
    call = Stories::CreateService
           .new(user: current_user)
           .call(attributes: story_params,
                 prev: params[:prev])

    respond_with_story(call)
  end

  def update
    story = Story.find(params[:id])

    call = Stories::UpdateService
           .new(user: current_user, story: story)
           .call(attributes: story_params,
                 prev: params[:prev])

    unless call.success?
      # reload the story to be able to display it correctly
      call.result.reload
    end

    respond_with_story(call)
  end

  private

  def respond_with_story(call)
    status = call.success? ? 200 : 400
    story = call.result

    respond_to do |format|
      format.html { render partial: 'story', object: story, status: status, locals: { errors: call.errors } }
    end
  end

  def story_params
    params.permit(PERMITTED_PARAMS).merge(project: @project).to_h
  end
end
