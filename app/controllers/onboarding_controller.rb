#-- encoding: UTF-8



class OnboardingController < ApplicationController
  def user_settings
    @user = User.current

    result = Users::UpdateService
             .new(model: @user, user: @user)
             .call(permitted_params.user.to_h)

    if result.success?
      flash[:notice] = I18n.t(:notice_account_updated)
    end

    # Remove all query params:
    # the first_time_user param so that the modal is not shown again after redirect,
    # the welcome param so that the analytics is not fired again
    uri = Addressable::URI.parse(request.referrer.to_s)
    uri.query_values = {}
    redirect_to uri.to_s
  end
end
