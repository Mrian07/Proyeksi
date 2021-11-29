#-- encoding: UTF-8


require 'rinku'

module OpenProject::TextFormatting
  module Filters
    # HTML Filter for auto_linking urls in HTML.
    #
    # Context options:
    #
    #   autolink:
    #     classes: (string) Classes to add to auto linked urls and mails
    #     enabled: (boolean)
    #
    # This filter does not write additional information to the context.
    class AutolinkFilter < HTML::Pipeline::Filter
      def call
        autolink_context = default_autolink_options.merge context.fetch(:autolink, {})
        return doc if autolink_context[:enabled] == false

        ::Rinku.auto_link(html, :all, "class=\"#{autolink_context[:classes]}\"")
      end

      def default_autolink_options
        {
          enabled: true,
          # Having to specify the link class again here is unfortunate. But as rinku seems to run latest,
          # it cannot receive the link class like all the rest of the links.
          classes: 'op-uc-link'
        }
      end
    end
  end
end
