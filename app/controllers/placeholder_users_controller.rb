#-- encoding: UTF-8

class PlaceholderUsersController < ApplicationController
  layout 'admin'

  helper_method :gon

  before_action :authorize_global, except: %i[show]

  before_action :find_placeholder_user, only: %i[show
                                                 edit
                                                 update
                                                 deletion_info
                                                 destroy]

  before_action :authorize_deletion, only: %i[deletion_info destroy]


  def index
    @placeholder_users = PlaceholderUsers::PlaceholderUserFilterCell.query params

    respond_to do |format|
      format.html do
        render layout: !request.xhr?
      end
    end
  end

  def show
    # show projects based on current user visibility
    @memberships = @placeholder_user.memberships
                                    .visible(current_user)

    respond_to do |format|
      format.html { render layout: 'no_menu' }
    end
  end

  def new
    @placeholder_user = PlaceholderUsers::SetAttributesService
                          .new(user: User.current,
                               model: PlaceholderUser.new,
                               contract_class: EmptyContract)
                          .call({})
                          .result
  end

  def create
    service = PlaceholderUsers::CreateService.new(user: User.current)
    service_result = service.call(permitted_params.placeholder_user)
    @placeholder_user = service_result.result

    if service_result.success?
      respond_to do |format|
        format.html do
          flash[:notice] = I18n.t(:notice_successful_create)
          redirect_to(params[:continue] ? new_placeholder_user_path : edit_placeholder_user_path(@placeholder_user))
        end
      end
    else
      @errors = service_result.errors
      respond_to do |format|
        format.html do
          render action: :new
        end
      end
    end
  end

  def edit
    @membership ||= Member.new
    @individual_principal = @placeholder_user
  end

  def update
    service_result = PlaceholderUsers::UpdateService
                       .new(user: User.current,
                            model: @placeholder_user)
                       .call(permitted_params.placeholder_user)

    if service_result.success?
      respond_to do |format|
        format.html do
          flash[:notice] = I18n.t(:notice_successful_update)
          redirect_back(fallback_location: edit_placeholder_user_path(@placeholder_user))
        end
      end
    else
      @membership ||= Member.new

      respond_to do |format|
        format.html do
          render action: :edit
        end
      end
    end
  end

  def deletion_info
    respond_to :html
  end

  def destroy
    PlaceholderUsers::DeleteService
      .new(user: User.current, model: @placeholder_user)
      .call

    flash[:info] = I18n.t(:notice_deletion_scheduled)

    respond_to do |format|
      format.html do
        redirect_to placeholder_users_path
      end
    end
  end

  private

  def find_placeholder_user
    @placeholder_user = PlaceholderUser.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  protected

  def authorize_deletion
    unless helpers.can_delete_placeholder_user?(@placeholder_user, current_user)
      render_403 message: I18n.t('placeholder_users.right_to_manage_members_missing')
    end
  end

  def default_breadcrumb
    if action_name == 'index'
      t('label_placeholder_user_plural')
    else
      ActionController::Base.helpers.link_to(t('label_placeholder_user_plural'),
                                             placeholder_users_path)
    end
  end

  def show_local_breadcrumb
    action_name != 'show'
  end
end
