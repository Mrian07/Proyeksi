

require 'icalendar'
require 'icalendar/tzinfo'

class MeetingMailer < UserMailer
  def content_for_review(content, content_type, user)
    @author = User.current
    @meeting = content.meeting
    @content_type = content_type

    proyeksi_app_headers 'Project' => @meeting.project.identifier,
                         'Meeting-Id' => @meeting.id

    User.execute_as(user) do
      subject = "[#{@meeting.project.name}] #{I18n.t(:"label_#{content_type}")}: #{@meeting.title}"
      mail to: user.mail, subject: subject
    end
  end

  def icalendar_notification(content, content_type, user)
    @meeting = content.meeting
    @content_type = content_type

    proyeksi_app_headers 'Project' => @meeting.project.identifier,
                         'Meeting-Id' => @meeting.id
    headers['Content-Type'] = 'text/calendar; charset=utf-8; method="PUBLISH"; name="meeting.ics"'
    headers['Content-Transfer-Encoding'] = '8bit'

    author = Icalendar::Values::CalAddress.new("mailto:#{@meeting.author.mail}",
                                               cn: @meeting.author.name)

    # Create a calendar with an event (standard method)
    entry = ::Icalendar::Calendar.new

    User.execute_as(user) do
      subject = "[#{@meeting.project.name}] #{I18n.t(:"label_#{@content_type}")}: #{@meeting.title}"
      timezone = Time.zone || Time.zone_default
      # Get the tzinfo object from the rails timezone
      tzinfo = timezone.tzinfo
      # Get the global identifier like Europe/Berlin
      tzid = tzinfo.canonical_identifier
      entry.add_timezone tzinfo.ical_timezone(@meeting.start_time)

      entry.event do |e|
        e.dtstart     = Icalendar::Values::DateTime.new @meeting.start_time, 'tzid' => tzid
        e.dtend       = Icalendar::Values::DateTime.new @meeting.end_time, 'tzid' => tzid
        e.url         = meeting_url(@meeting)
        e.summary     = "[#{@meeting.project.name}] #{@meeting.title}"
        e.description = subject
        e.uid         = "#{@meeting.id}@#{@meeting.project.identifier}"
        e.organizer   = author
      end

      attachments['meeting.ics'] = entry.to_ical
      mail(to: user.mail, subject: subject)
    end
  end
end
