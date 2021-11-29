#-- encoding: UTF-8


require 'spec_helper'

shared_context 'with a mentioned work package being updated again' do
  let(:project) { FactoryBot.create :project }

  let(:work_package) do
    FactoryBot.create(:work_package, project: project).tap do |wp|
      # Clear the initial journal job
      wp.save!
      clear_enqueued_jobs
    end
  end

  let(:role) do
    FactoryBot.create :role, permissions: %w[view_work_packages edit_work_packages]
  end

  let(:recipient) do
    FactoryBot.create :user,
                      preferences: {
                        immediate_reminders: {
                          mentioned: true
                        }
                      },
                      notification_settings: [
                        FactoryBot.build(:notification_setting,
                                         mentioned: true,
                                         involved: true)
                      ],
                      member_in_project: project,
                      member_through_role: role
  end
  let(:actor) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end

  let(:comment) do
    <<~NOTE
      Hello <mention class="mention" data-type="user" data-id="#{recipient.id}" data-text="@#{recipient.name}">@#{recipient.name}</mention>
    NOTE
  end

  let(:mentioned_notification) do
    Notification.find_by(recipient: recipient, journal: work_package.journals.last, reason: :mentioned)
  end

  let(:assigned_notification) do
    Notification.find_by(recipient: recipient, journal: work_package.journals.last, reason: :assigned)
  end

  def trigger_comment!
    User.execute_as(actor) do
      work_package.journal_notes = comment
      work_package.save!
    end

    perform_enqueued_jobs
    work_package.reload
  end

  def update_assignee!
    clear_enqueued_jobs

    User.execute_as(actor) do
      work_package.assigned_to = recipient
      work_package.save!
    end

    perform_enqueued_jobs
    work_package.reload
  end
end
