

class MeetingContentsController < ApplicationController
  include AttachableServiceCall
  include PaginationHelper

  menu_item :meetings

  helper :watchers
  helper :wiki
  helper :meetings
  helper :meeting_contents
  helper :watchers
  helper :meetings

  helper_method :gon

  before_action :find_meeting, :find_content
  before_action :authorize

  def show
    if params[:id].present? && @content.last_journal.version == params[:id].to_i
      # Redirect links to the last version
      redirect_to controller: '/meetings',
                  action: :show,
                  id: @meeting,
                  tab: @content_type.sub(/^meeting_/, '')
      return
    end

    # go to an old version if a version id is given
    @journaled_version = true
    @content = @content.at_version params[:id] unless params[:id].blank?
    render 'meeting_contents/show'
  end

  def update
    call = attachable_update_call ::MeetingContents::UpdateService,
                                  model: @content,
                                  args: content_params

    if call.success?
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_back_or_default controller: '/meetings', action: 'show', id: @meeting
    else
      flash.now[:error] = call.message
      params[:tab] ||= 'minutes' if @meeting.agenda.present? && @meeting.agenda.locked?
      render 'meetings/show'
    end
  end

  def history
    # don't load text
    @content_versions = @content.journals.select('id, user_id, notes, created_at, version')
                                .order(Arel.sql('version DESC'))
                                .page(page_param)
                                .per_page(per_page_param)

    render 'meeting_contents/history', layout: !request.xhr?
  end

  def diff
    @diff = @content.diff(params[:version_to], params[:version_from])
    render 'meeting_contents/diff'
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def notify
    unless @content.new_record?
      service = MeetingNotificationService.new(@meeting, @content_type)
      result = service.call(@content, :content_for_review)

      if result.success?
        flash[:notice] = I18n.t(:notice_successful_notification)
      else
        flash[:error] = I18n.t(:error_notification_with_errors,
                               recipients: result.errors.map(&:name).join('; '))
      end
    end
    redirect_back_or_default controller: '/meetings', action: 'show', id: @meeting
  end

  def icalendar
    unless @content.new_record?
      service = MeetingNotificationService.new(@meeting, @content_type)
      result = service.call(@content, :icalendar_notification, include_author: true)

      if result.success?
        flash[:notice] = I18n.t(:notice_successful_notification)
      else
        flash[:error] = I18n.t(:error_notification_with_errors,
                               recipients: result.errors.map(&:name).join('; '))
      end
    end
    redirect_back_or_default controller: '/meetings', action: 'show', id: @meeting
  end

  def default_breadcrumb
    MeetingsController.new.send(:default_breadcrumb)
  end

  private

  def find_meeting
    @meeting = Meeting.includes(:project, :author, :participants, :agenda, :minutes)
                      .find(params[:meeting_id])
    @project = @meeting.project
    @author = User.current
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def content_params
    params.require(@content_type).permit(:text, :lock_version, :journal_notes)
  end
end
