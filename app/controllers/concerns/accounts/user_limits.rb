##
# Intended to be used by the UsersController to enforce the user limit.
module Accounts::UserLimits
  def enforce_user_limit(
    redirect_to: users_path,
    hard: ProyeksiApp::Enterprise.fail_fast?,
    flash_now: false
  )
    if user_limit_reached?
      if hard
        show_user_limit_error!

        redirect_back fallback_location: redirect_to
      else
        show_user_limit_warning! flash_now: flash_now
      end

      true
    elsif imminent_user_limit?
      show_imminent_user_limit_warning! flash_now: flash_now

      true
    else
      false
    end
  end

  def enforce_activation_user_limit(user: nil, redirect_to: signin_path)
    if user_limit_reached?
      flash[:error] = I18n.t(:error_enterprise_activation_user_limit)
      send_activation_limit_notification_about user if user

      redirect_back fallback_location: redirect_to

      true
    else
      false
    end
  end

  ##
  # Ensures that the given user object has an email set.
  # If it hasn't it takes the value from the params.
  def user_with_email(user)
    user.mail = permitted_params.user["mail"] if user.mail.blank?
    user
  end

  def send_activation_limit_notification_about(user)
    ProyeksiApp::Enterprise.send_activation_limit_notification_about user
  end

  def show_user_limit_warning!(flash_now: false)
    f = flash_now ? flash.now : flash

    f[:warning] = user_limit_warning
  end

  def show_user_limit_error!
    flash[:error] = user_limit_warning
  end

  def user_limit_warning
    warning = I18n.t(
      :warning_user_limit_reached,
      upgrade_url: ProyeksiApp::Enterprise.upgrade_url
    )

    warning.html_safe
  end

  def show_imminent_user_limit_warning!(flash_now: false)
    f = flash_now ? flash.now : flash

    f[:warning] = imminent_user_limit_warning
  end

  ##
  # A warning for when the user limit has technically not been reached yet
  # but if all invited users were to activate their accounts it would be reached.
  def imminent_user_limit_warning
    warning = I18n.t(
      :warning_imminent_user_limit,
      upgrade_url: ProyeksiApp::Enterprise.upgrade_url
    )

    warning.html_safe
  end

  def user_limit_reached?
    ProyeksiApp::Enterprise.user_limit_reached?
  end

  def imminent_user_limit?
    ProyeksiApp::Enterprise.imminent_user_limit?
  end
end
