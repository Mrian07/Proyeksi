#-- encoding: UTF-8



module OAuth
  class GrantsController < ::ApplicationController
    before_action :require_login

    layout 'my'
    menu_item :access_token

    def index
      @applications = ::Doorkeeper::Application.authorized_for(current_user)
    end

    def revoke_application
      application = find_application
      if application.nil?
        render_404
        return
      end

      ::Doorkeeper::Application.revoke_tokens_and_grants_for(
        application.id,
        current_user
      )

      flash[:notice] = I18n.t('oauth.grants.successful_application_revocation', application_name: application.name)
      redirect_to controller: '/my', action: :access_token
    end

    private

    def find_application
      ::Doorkeeper::Application
        .where(id: params[:application_id])
        .select(:name, :id)
        .take
    end
  end
end
