#-- encoding: UTF-8

module Admin
  class SettingsController < ApplicationController
    layout 'admin'
    before_action :require_admin
    before_action :find_plugin, only: %i[show_plugin update_plugin]

    helper_method :gon

    current_menu_item [:show] do
      :settings
    end

    current_menu_item :show_plugin do |controller|
      plugin = Redmine::Plugin.find(controller.params[:id])
      plugin.settings[:menu_item] || :settings
    rescue Redmine::PluginNotFound
      :settings
    end

    def show
      respond_to :html
    end

    def update
      return unless params[:settings]

      call = ::Settings::UpdateService
               .new(user: current_user)
               .call(settings_params)

      call.on_success { flash[:notice] = t(:notice_successful_update) }
      call.on_failure { flash[:error] = call.message || I18n.t(:notice_internal_server_error) }
      redirect_to action: 'show', tab: params[:tab]
    end

    def show_plugin
      @partial = @plugin.settings[:partial]
      @settings = Setting["plugin_#{@plugin.id}"]
    end

    def update_plugin
      Setting["plugin_#{@plugin.id}"] = params[:settings].permit!.to_h
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to action: :show_plugin, id: @plugin.id
    end

    def show_local_breadcrumb
      true
    end

    def default_breadcrumb
      if @plugin
        @plugin.name
      else
        I18n.t(:label_setting_plural)
      end
    end

    protected

    def find_plugin
      @plugin = Redmine::Plugin.find(params[:id])
    rescue Redmine::PluginNotFound
      render_404
    end

    def settings_params
      permitted_params.settings.to_h
    end
  end
end
