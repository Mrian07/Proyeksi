##
# Intended to be used by the AccountController to decide where to
# send the user when they logged in.
module Accounts::RedirectAfterLogin
  def redirect_after_login(user)
    if user.first_login
      user.update_attribute(:first_login, false)

      call_hook :user_first_login, { user: user }

      first_login_redirect
    else
      default_redirect
    end
  end

  #    * * *

  def default_redirect
    if url = ProyeksiApp::Configuration.after_login_default_redirect_url
      redirect_to url
    else
      redirect_back_or_default my_page_path
    end
  end

  def first_login_redirect
    if url = ProyeksiApp::Configuration.after_first_login_redirect_url
      redirect_to url
    else
      redirect_to home_url(first_time_user: true)
    end
  end
end
