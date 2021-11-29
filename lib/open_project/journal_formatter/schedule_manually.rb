

class OpenProject::JournalFormatter::ScheduleManually < JournalFormatter::Base
  def render(key, values, options = { no_html: false })
    label_text = options[:no_html] ? label(key) : content_tag('strong', label(key))
    activated_text = values.last ? I18n.t('scheduling.activated') : I18n.t('scheduling.deactivated')

    I18n.t(:text_journal_label_value, label: label_text, value: activated_text)
  end
end
