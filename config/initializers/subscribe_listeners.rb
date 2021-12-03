#-- encoding: UTF-8



ProyeksiApp::Notifications.subscribe(ProyeksiApp::Events::JOURNAL_CREATED) do |payload|
  # A job is scheduled that creates notifications (in app if supported) right away and schedules
  # jobs to be run for mail and digest mails.
  Notifications::WorkflowJob
    .perform_later(:create_notifications,
                   payload[:journal],
                   payload[:send_notification])

  # A job is scheduled for the end of the journal aggregation time. If the journal does still exist
  # at the end (it might be replaced because another journal was created within that timeframe)
  # that job generates a ProyeksiApp::Events::AGGREGATED_..._JOURNAL_READY event.
  Journals::CompletedJob.schedule(payload[:journal], payload[:send_notification])
end

ProyeksiApp::Notifications.subscribe(ProyeksiApp::Events::JOURNAL_AGGREGATE_BEFORE_DESTROY) do |payload|
  Notifications::AggregatedJournalService.relocate_immediate(**payload.slice(:journal, :predecessor))
end

ProyeksiApp::Notifications.subscribe(ProyeksiApp::Events::WATCHER_ADDED) do |payload|
  next unless payload[:send_notifications]

  Mails::WatcherAddedJob
    .perform_later(payload[:watcher],
                   payload[:watcher_setter])
end

ProyeksiApp::Notifications.subscribe(ProyeksiApp::Events::WATCHER_REMOVED) do |payload|
  Mails::WatcherRemovedJob
    .perform_later(payload[:watcher].attributes,
                   payload[:watcher_remover])
end

ProyeksiApp::Notifications.subscribe(ProyeksiApp::Events::MEMBER_CREATED) do |payload|
  next unless payload[:send_notifications]

  Mails::MemberCreatedJob
    .perform_later(current_user: User.current,
                   member: payload[:member],
                   message: payload[:message])
end

ProyeksiApp::Notifications.subscribe(ProyeksiApp::Events::MEMBER_UPDATED) do |payload|
  Mails::MemberUpdatedJob
    .perform_later(current_user: User.current,
                   member: payload[:member],
                   message: payload[:message])
end

ProyeksiApp::Notifications.subscribe(ProyeksiApp::Events::NEWS_COMMENT_CREATED) do |payload|
  Notifications::WorkflowJob
    .perform_later(:create_notifications,
                   payload[:comment],
                   payload[:send_notification])
end
