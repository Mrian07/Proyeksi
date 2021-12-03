##
# The default behaviour is to send the user a sign-up mail
# when they were invited.
ProyeksiApp::Notifications.subscribe UserInvitation::Events.user_invited do |token|
  Mails::InvitationJob.perform_later(token)
end

ProyeksiApp::Notifications.subscribe UserInvitation::Events.user_reinvited do |token|
  Mails::InvitationJob.perform_later(token)
end
