#-- encoding: UTF-8

module Users
  class LogoutService
    attr_accessor :controller

    def initialize(controller:)
      self.controller = controller
    end

    def call(user)
      controller.reset_session

      if user.logged?
        remove_cookies! controller.send(:cookies)
        remove_tokens! user
      end

      User.current = User.anonymous
      ServiceResult.new(result: User.anonymous)
    end

    private

    def remove_tokens!(user)
      Token::AutoLogin.where(user_id: user.id).delete_all
    end

    def remove_cookies!(cookies)
      cookies.delete ProyeksiApp::Configuration.autologin_cookie_name
    end
  end
end
