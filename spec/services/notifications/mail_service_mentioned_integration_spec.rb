#-- encoding: UTF-8



require 'spec_helper'
require_relative './mentioned_journals_shared'


describe Notifications::MailService, 'Mentioned integration', type: :model do
  include_context 'with a mentioned work package being updated again'

  def expect_mentioned_notification
    expect(mentioned_notification).to be_present
    expect(mentioned_notification.reason).to eq 'mentioned'
    expect(mentioned_notification.read_ian).to eq false
    expect(mentioned_notification.mail_alert_sent).to eq true
  end

  def expect_mentioned_notification_updated
    old_journal_id = mentioned_notification.journal_id
    mentioned_notification.reload
    expect(mentioned_notification.journal_id).not_to eq old_journal_id
    expect(mentioned_notification.journal).to eq work_package.journals.last
    expect(mentioned_notification.reason).to eq 'mentioned'
    expect(mentioned_notification.read_ian).to eq false
    expect(mentioned_notification.mail_alert_sent).to eq true
  end

  def expect_assigned_notification
    expect(assigned_notification).to be_present
    expect(assigned_notification.read_ian).to eq false
    expect(assigned_notification.mail_alert_sent).to eq false
  end

  it 'will trigger only one mention notification mail when editing attributes afterwards' do
    allow(WorkPackageMailer)
      .to(receive(:mentioned))
      .and_call_original

    trigger_comment!

    expect(WorkPackageMailer)
      .to have_received(:mentioned)
      .with(recipient, work_package.journals.last)

    expect_mentioned_notification

    update_assignee!

    expect(WorkPackageMailer)
      .not_to have_received(:mentioned)
      .with(recipient, work_package.journals.last)

    expect_mentioned_notification_updated
    expect_assigned_notification
  end
end
