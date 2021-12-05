class EnterprisesController < ApplicationController
  include EnterpriseTrialHelper

  layout 'admin'
  menu_item :enterprise

  helper_method :gon

  before_action :augur_content_security_policy
  before_action :chargebee_content_security_policy
  before_action :youtube_content_security_policy
  before_action :require_admin
  before_action :check_user_limit, only: [:show]
  before_action :check_domain, only: [:show]

  def show
    @current_token = EnterpriseToken.current
    @token = @current_token || EnterpriseToken.new
  end

  def create
    @token = EnterpriseToken.current || EnterpriseToken.new
    saved_encoded_token = @token.encoded_token
    @token.encoded_token = params[:enterprise_token][:encoded_token]
    if @token.save
      flash[:notice] = t(:notice_successful_update)
      respond_to do |format|
        format.html { redirect_to action: :show }
        format.json { head :no_content }
      end
    else
      # restore the old token
      if saved_encoded_token
        @token.encoded_token = saved_encoded_token
        @current_token = @token || EnterpriseToken.new
      end
      respond_to do |format|
        format.html { render action: :show }
        format.json { render json: { description: @token.errors.full_messages.join(", ") }, status: 400 }
      end
    end
  end

  def destroy
    token = EnterpriseToken.current
    if token
      token.destroy
      flash[:notice] = t(:notice_successful_delete)

      delete_trial_key

      redirect_to action: :show
    else
      render_404
    end
  end

  def save_trial_key
    Token::EnterpriseTrialKey.create(user_id: User.system.id, value: params[:trial_key])
  end

  def delete_trial_key
    Token::EnterpriseTrialKey.where(user_id: User.system.id).delete_all
  end

  private





  def default_breadcrumb
    t(:label_enterprise_edition)
  end

  def show_local_breadcrumb
    true
  end

  def check_user_limit
    if ProyeksiApp::Enterprise.user_limit_reached?
      flash.now[:warning] = I18n.t(
        "warning_user_limit_reached_instructions",
        current: ProyeksiApp::Enterprise.active_user_count,
        max: ProyeksiApp::Enterprise.user_limit
      )
    end
  end

  def check_domain
    if ProyeksiApp::Enterprise.token.try(:invalid_domain?)
      flash.now[:error] = I18n.t(
        "error_enterprise_token_invalid_domain",
        expected: Setting.host_name,
        actual: ProyeksiApp::Enterprise.token.domain
      )
    end
  end
end
