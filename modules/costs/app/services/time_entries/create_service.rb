#-- encoding: UTF-8



class TimeEntries::CreateService < ::BaseServices::Create
  def after_perform(call)
    ProyeksiApp::Notifications.send(
      ProyeksiApp::Events::TIME_ENTRY_CREATED,
      time_entry: call.result
    )

    call
  end
end
