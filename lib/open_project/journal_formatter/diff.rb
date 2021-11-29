

require_dependency 'journal_formatter/base'

class OpenProject::JournalFormatter::Diff < JournalFormatter::Base
  include OpenProject::StaticRouting::UrlHelpers

  def render(key, values, options = {})
    merge_options = { only_path: true,
                      no_html: false }.merge(options)

    render_ternary_detail_text(key, values.last, values.first, merge_options)
  end

  private

  def label(key, no_html = false)
    label = super key

    if no_html
      label
    else
      content_tag('strong', label)
    end
  end

  def render_ternary_detail_text(key, value, old_value, options)
    link = link(key, options)

    label = label(key, options[:no_html])

    if value.blank?
      I18n.t(:text_journal_deleted_with_diff, label: label, link: link)
    elsif old_value.present?
      I18n.t(:text_journal_changed_with_diff, label: label, link: link)
    else
      I18n.t(:text_journal_set_with_diff, label: label, link: link)
    end
  end

  # url_for wants to access the controller method, which we do not have in our Diff class.
  # see: http://stackoverflow.com/questions/3659455/is-there-a-new-syntax-for-url-for-in-rails-3
  def controller
    nil
  end

  def link(key, options)
    url_attr = default_attributes(options).merge(controller: '/journals',
                                                 action: 'diff',
                                                 id: @journal.id,
                                                 field: key.downcase)

    if options[:no_html]
      url_for url_attr
    else
      link_to(I18n.t(:label_details),
              url_attr,
              class: 'description-details')
    end
  end

  def default_attributes(options)
    if options[:only_path]
      { only_path: options[:only_path],
        # setting :script_name is a hack that allows for setting the sub uri.
        # I am not yet sure why url_for normally returns the sub uri but does not within
        # this class.
        script_name: ::OpenProject::Configuration.rails_relative_url_root }
    else
      { only_path: options[:only_path],
        protocol: Setting.protocol,
        host: Setting.host_name }
    end
  end
end
