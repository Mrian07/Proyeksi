

module MeetingsHelper
  def format_participant_list(participants)
    if participants.any?
      user_links = participants
        .sort
        .reject { |p| p.user.nil? }
        .map { |p| link_to_user p.user }

      safe_join(user_links, '; ')
    else
      t('placeholders.default')
    end
  end

  def render_meeting_journal(model, journal, options = {})
    return '' if journal.initial?

    journal_content = render_journal_details(journal, :label_updated_time_by, model, options)
    content_tag 'div', journal_content,  id: "change-#{journal.id}", class: 'journal'
  end

  # This renders a journal entry with a header and details
  def render_journal_details(journal, header_label = :label_updated_time_by, _model = nil, options = {})
    header = <<-HTML
      <div class="profile-wrap">
        #{avatar(journal.user)}
      </div>
      <h4>
        <div class="journal-link" style="float:right;">#{link_to "##{journal.anchor}", anchor: "note-#{journal.anchor}"}</div>
        #{authoring journal.created_at, journal.user, label: header_label}
        #{content_tag('a', '', name: "note-#{journal.anchor}")}
      </h4>
    HTML

    if journal.details.any?
      details = content_tag 'ul', class: 'details journal-attributes' do
        journal.details.map do |detail|
          if d = journal.render_detail(detail, cache: options[:cache])
            content_tag('li', d.html_safe)
          end
        end.compact.join(' ').html_safe
      end
    end

    content_tag('div', "#{header}#{details}".html_safe, id: "change-#{journal.id}", class: 'journal')
  end
end
