#-- encoding: UTF-8

module OAuth
  class ApplicationsController < ::ApplicationController
    before_action :require_admin
    before_action :new_app, only: %i[new create]
    before_action :find_app, only: %i[edit update show destroy]

    layout 'admin'
    menu_item :oauth_applications

    def index
      @applications = ::Doorkeeper::Application.includes(:owner).all
    end

    def new; end

    def edit; end

    def show
      @reveal_secret = flash[:reveal_secret]
      flash.delete :reveal_secret
    end

    def create
      call = ::OAuth::PersistApplicationService.new(@application, user: current_user)
                                               .call(permitted_params.oauth_application)

      if call.success?
        flash[:notice] = t(:notice_successful_create)
        flash[:_application_secret] = call.result.plaintext_secret
        redirect_to action: :show, id: call.result.id
      else
        @errors = call.errors
        flash[:error] = call.errors.full_messages.join('\n')
        render action: :new
      end
    end

    def update
      call = ::OAuth::PersistApplicationService.new(@application, user: current_user)
                                               .call(permitted_params.oauth_application)

      if call.success?
        flash[:notice] = t(:notice_successful_update)
        redirect_to action: :index
      else
        @errors = call.errors
        flash[:error] = call.errors.full_messages.join('\n')
        render action: :edit
      end
    end

    def destroy
      if @application.destroy
        flash[:notice] = t(:notice_successful_delete)
      else
        flash[:error] = t(:error_can_not_delete_entry)
      end

      redirect_to action: :index
    end

    protected

    def default_breadcrumb
      if action_name == 'index'
        t('oauth.application.plural')
      else
        ActionController::Base.helpers.link_to(t('oauth.application.plural'), oauth_applications_path)
      end
    end

    def show_local_breadcrumb
      current_user.admin?
    end

    private

    def new_app
      @application = ::Doorkeeper::Application.new
    end

    def find_app
      @application = ::Doorkeeper::Application.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
end
