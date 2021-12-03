#-- encoding: UTF-8

module Users
  class ChangePasswordService
    attr_accessor :current_user, :session

    def initialize(current_user:, session:)
      @current_user = current_user
      @session = session
    end

    def call(params)
      User.execute_as current_user do
        current_user.password = params[:new_password]
        current_user.password_confirmation = params[:new_password_confirmation]
        current_user.force_password_change = false

        if current_user.save
          log_success
          ::ServiceResult.new success: true,
                              result: current_user,
                              **invalidate_session_result
        else
          log_failure
          ::ServiceResult.new success: false,
                              result: current_user,
                              message: I18n.t(:error_password_change_failed),
                              errors: current_user.errors
        end
      end
    end

    private

    def invalidate_session_result
      update_message = I18n.t(:notice_account_password_updated)

      if ::Sessions::DropOtherSessionsService.call(current_user, session)
        expiry_message = I18n.t(:notice_account_other_session_expired)
        { message_type: :info, message: "#{update_message} #{expiry_message}" }
      else
        { message: update_message }
      end
    end

    def log_success
      Rails.logger.info do
        "User #{current_user.login} changed password successfully."
      end
    end

    def log_failure
      Rails.logger.info do
        "User #{current_user.login} failed password change: #{current_user.errors.full_messages.join(', ')}."
      end
    end
  end
end
