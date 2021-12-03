#-- encoding: UTF-8

module Mails::WithSender
  def perform(recipient_id, sender_id)
    self.sender_id = sender_id

    super(recipient_id)
  end

  private

  attr_accessor :sender_id

  def sender
    @sender ||= if sender_id.is_a?(User)
                  sender_id
                else
                  User.find_by(id: sender_id) || DeletedUser.first
                end
  end
end
