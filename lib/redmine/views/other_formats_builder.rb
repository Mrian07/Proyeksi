#-- encoding: UTF-8



module Redmine
  module Views
    class OtherFormatsBuilder
      def initialize(view)
        @view = view
      end

      def link_to(name, options = {})
        return if Setting.table_exists? && !Setting.feeds_enabled? && name == 'Atom'

        url = { format: name.to_s.downcase }.merge(options.delete(:url) || {})
        caption = options.delete(:caption) || name
        html_options = { class: "icon icon-#{name.to_s.downcase}", rel: 'nofollow' }.merge(options)
        @view.content_tag('span', @view.link_to(caption, url, html_options))
      end
    end
  end
end
