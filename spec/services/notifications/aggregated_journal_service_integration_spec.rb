#-- encoding: UTF-8



require 'spec_helper'
require_relative './mentioned_journals_shared'

describe Notifications::AggregatedJournalService, 'integration', type: :model do
  include_context 'with a mentioned work package being updated again'

  it 'will relocate the notification to the newer journal' do
    trigger_comment!

    expect(mentioned_notification).to be_present
    journal = mentioned_notification.journal

    update_assignee!

    expect(mentioned_notification.reload).to be_present
    expect(mentioned_notification.journal).not_to eq journal
    expect { journal.reload }.to raise_error(ActiveRecord::RecordNotFound)

    # Expect only one notification to be present
    expect(Notification.where(recipient: recipient, reason: :mentioned).count)
      .to eq 1
  end
end
