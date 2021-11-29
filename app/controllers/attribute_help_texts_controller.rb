#-- encoding: UTF-8



class AttributeHelpTextsController < ApplicationController
  layout 'admin'
  menu_item :attribute_help_texts

  before_action :require_admin
  before_action :find_entry, only: %i(edit update destroy)
  before_action :find_type_scope
  before_action :require_enterprise_token_grant

  helper_method :gon

  def new
    @attribute_help_text = AttributeHelpText.new type: @attribute_scope
  end

  def edit; end

  def update
    call = ::AttributeHelpTexts::UpdateService
      .new(user: current_user, model: @attribute_help_text)
      .call(permitted_params_with_attachments)

    if call.success?
      flash[:notice] = t(:notice_successful_update)
      redirect_to attribute_help_texts_path(tab: @attribute_help_text.attribute_scope)
    else
      flash[:error] = call.message || I18n.t('notice_internal_server_error')
      render action: 'edit'
    end
  end

  def create
    call = ::AttributeHelpTexts::CreateService
      .new(user: current_user)
      .call(permitted_params_with_attachments)

    if call.success?
      flash[:notice] = t(:notice_successful_create)
      redirect_to attribute_help_texts_path(tab: call.result.attribute_scope)
    else
      @attribute_help_text = call.result
      flash[:error] = call.message || I18n.t('notice_internal_server_error')
      render action: 'new'
    end
  end

  def destroy
    if @attribute_help_text.destroy
      flash[:notice] = t(:notice_successful_delete)
    else
      flash[:error] = t(:error_can_not_delete_entry)
    end

    redirect_to attribute_help_texts_path(tab: @attribute_help_text.attribute_scope)
  end

  def index
    @texts_by_type = AttributeHelpText.all_by_scope
  end

  protected

  def default_breadcrumb
    if action_name == 'index'
      t('attribute_help_texts.label_plural')
    else
      ActionController::Base.helpers.link_to(t('attribute_help_texts.label_plural'), attribute_help_texts_path)
    end
  end

  def show_local_breadcrumb
    true
  end

  private

  def permitted_params_with_attachments
    permitted_params.attribute_help_text.merge(attachment_params)
  end

  def attachment_params
    attachment_params = permitted_params.attachments.to_h

    if attachment_params.any?
      { attachment_ids: attachment_params.values.map(&:values).flatten }
    else
      {}
    end
  end

  def find_entry
    @attribute_help_text = AttributeHelpText.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_type_scope
    name = params.fetch(:name, 'WorkPackage')
    submodule = AttributeHelpText.available_types.find { |mod| mod == name }

    if submodule.nil?
      render_404
    end

    @attribute_scope = AttributeHelpText.const_get(submodule)
  end

  def require_enterprise_token_grant
    render_404 unless EnterpriseToken.allows_to?(:attribute_help_texts)
  end
end
