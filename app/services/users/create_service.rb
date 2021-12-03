#-- encoding: UTF-8

require 'work_packages/create_contract'
require 'concerns/user_invitation'

module Users
  class CreateService < ::BaseServices::Create
    private

    def persist(call)
      new_user = call.result

      return super(call) unless new_user.invited?

      # As we're basing on the user's mail, this parameter is required
      # before we're able to validate the contract or user
      return fail_with_missing_email(new_user) if new_user.mail.blank?

      invite_user!(new_user)
    end

    def fail_with_missing_email(new_user)
      ServiceResult.new(success: false, result: new_user).tap do |result|
        result.errors.add :mail, :blank
      end
    end

    def invite_user!(new_user)
      invited = ::UserInvitation.invite_user! new_user
      new_user.errors.add :base, I18n.t(:error_can_not_invite_user) unless invited.is_a? User

      ServiceResult.new(success: new_user.errors.empty?, result: invited)
    end
  end
end
