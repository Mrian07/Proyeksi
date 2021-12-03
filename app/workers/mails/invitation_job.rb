#-- encoding: UTF-8

class Mails::InvitationJob < ApplicationJob
  queue_with_priority :high

  def perform(token)
    if token
      UserMailer.user_signed_up(token).deliver_later
    else
      Rails.logger.warn "Can't deliver invitation. The token is missing."
    end
  end
end
