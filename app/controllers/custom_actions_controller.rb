#-- encoding: UTF-8

class CustomActionsController < ApplicationController
  before_action :require_admin
  before_action :require_enterprise_token

  self._model_object = CustomAction
  before_action :find_model_object, only: %i(edit update destroy)
  before_action :pad_params, only: %i(create update)

  layout 'admin'

  helper_method :gon

  def index
    @custom_actions = CustomAction.order_by_position
  end

  def new
    @custom_action = CustomAction.new
  end

  def create
    CustomActions::CreateService
      .new(user: current_user)
      .call(attributes: permitted_params.custom_action.to_h,
            &index_or_render(:new))
  end

  def edit; end

  def update
    CustomActions::UpdateService
      .new(action: @custom_action, user: current_user)
      .call(attributes: permitted_params.custom_action.to_h,
            &index_or_render(:edit))
  end

  def destroy
    @custom_action.destroy

    redirect_to custom_actions_path
  end

  private

  def index_or_render(render_action)
    ->(call) {
      call.on_success do
        redirect_to custom_actions_path
      end

      call.on_failure do
        @custom_action = call.result
        @errors = call.errors
        render action: render_action
      end
    }
  end

  def require_enterprise_token
    return if EnterpriseToken.allows_to?(:custom_actions)

    if request.get?
      render template: 'common/upsale',
             locals: {
               feature_title: I18n.t('custom_actions.upsale.title'),
               feature_description: I18n.t('custom_actions.upsale.description'),
               feature_reference: 'custom_actions_admin'
             }
    else
      render_403
    end
  end

  # If no action/condition is set in the view, the
  # actions/conditions already existing on a custom action should be removed.
  # But because it is not feasible to have an empty and hidden hash object in a form
  # we have to pad the params here.
  def pad_params
    return if !params[:custom_action] || params[:custom_action][:move_to]

    params[:custom_action][:conditions] ||= {}
    params[:custom_action][:actions] ||= {}
  end

  def default_breadcrumb
    if action_name == 'index'
      t('custom_actions.plural')
    else
      ActionController::Base.helpers.link_to(t('custom_actions.plural'), custom_actions_path)
    end
  end

  def show_local_breadcrumb
    true
  end
end
