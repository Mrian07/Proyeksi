
#

class MeetingContent < ApplicationRecord
  include ProyeksiApp::Journal::AttachmentHelper

  belongs_to :meeting
  belongs_to :author, class_name: 'User'

  acts_as_attachable(
    after_remove: :attachments_changed,
    order: "#{Attachment.table_name}.file",
    add_on_new_permission: :create_meetings,
    add_on_persisted_permission: :edit_meetings,
    view_permission: :view_meetings,
    delete_permission: :edit_meetings,
    modification_blocked: ->(*) { false }
  )

  acts_as_journalized
  acts_as_event type: Proc.new { |o| o.class.to_s.underscore.dasherize.to_s },
                title: Proc.new { |o| "#{o.class.model_name.human}: #{o.meeting.title}" },
                url: Proc.new { |o| { controller: '/meetings', action: 'show', id: o.meeting } }

  def editable?
    true
  end

  def diff(version_to = nil, version_from = nil)
    version_to = version_to ? version_to.to_i : version
    version_from = version_from ? version_from.to_i : version_to - 1
    version_to, version_from = version_from, version_to unless version_from < version_to

    content_to = journals.find_by_version(version_to)
    content_from = journals.find_by_version(version_from)

    content_to && content_from ? Wikis::Diff.new(content_to, content_from) : nil
  end

  def at_version(version)
    journals
      .joins("JOIN meeting_contents ON meeting_contents.id = journals.journable_id AND meeting_contents.type='#{self.class}'")
      .where(version: version)
      .first.data
  end

  # Show the project on activity and search views
  delegate :project, to: :meeting
end
