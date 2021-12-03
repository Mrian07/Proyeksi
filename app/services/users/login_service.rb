#-- encoding: UTF-8

module Users
  class LoginService
    attr_accessor :controller

    def initialize(controller:)
      self.controller = controller
    end

    def call(user)
      # retain custom session values
      retained_values = retain_sso_session_values!(user)

      # retain flash values
      flash_values = controller.flash.to_h

      controller.reset_session

      flash_values.each { |k, v| controller.flash[k] = v }

      User.current = user

      ::Sessions::InitializeSessionService.call(user, controller.session)

      controller.session.merge!(retained_values) if retained_values

      user.log_successful_login

      ServiceResult.new(result: user)
    end

    def retain_sso_session_values!(user)
      provider = ::ProyeksiApp::Plugins::AuthPlugin.login_provider_for(user)
      return unless provider && provider[:retain_from_session]

      controller.session.to_h.slice(*provider[:retain_from_session])
    end
  end
end
