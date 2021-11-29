

class ExportCardConfigurationsController < ApplicationController
  layout 'admin'

  before_action :require_admin
  before_action :load_config, only: %i[show update edit destroy activate deactivate]
  before_action :load_configs, only: [:index]

  def index; end

  def show; end

  def edit; end

  def new
    @config = ExportCardConfiguration.new
  end

  def create
    @config = ExportCardConfiguration.new(export_card_configurations_params)
    if @config.save
      flash[:notice] = I18n.t(:notice_successful_create)
      redirect_to action: 'index'
    else
      render "new"
    end
  end

  def update
    if cannot_update_default
      flash[:error] = I18n.t(:error_can_not_change_name_of_default_configuration)
      render "edit"
    elsif @config.update(export_card_configurations_params)
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to action: 'index'
    else
      render "edit"
    end
  end

  def destroy
    flash[:notice] = if !@config.is_default? && @config.destroy
                       I18n.t(:notice_successful_delete)
                     else
                       I18n.t(:error_can_not_delete_export_card_configuration)
                     end
    redirect_to action: 'index'
  end

  def activate
    flash[:notice] = if @config.activate
                       I18n.t(:notice_export_card_configuration_activated)
                     else
                       I18n.t(:error_can_not_activate_export_card_configuration)
                     end
    redirect_to action: 'index'
  end

  def deactivate
    flash[:notice] = if @config.deactivate
                       I18n.t(:notice_export_card_configuration_deactivated)
                     else
                       I18n.t(:error_can_not_deactivate_export_card_configuration)
                     end
    redirect_to action: 'index'
  end

  def show_local_breadcrumb
    true
  end

  private

  def cannot_update_default
    @config.is_default? && export_card_configurations_params[:name].downcase != "default"
  end

  def export_card_configurations_params
    params.require(:export_card_configuration).permit(:name, :rows, :per_page, :page_size, :orientation, :description)
  end

  def load_config
    @config = ExportCardConfiguration.find(params[:id])
  end

  def load_configs
    @configs = ExportCardConfiguration.all
  end

  protected

  def default_breadcrumb
    if action_name == 'index'
      t('label_export_card_configuration')
    else
      ActionController::Base.helpers.link_to(t('label_export_card_configuration'), pdf_export_export_card_configurations_path)
    end
  end
end
