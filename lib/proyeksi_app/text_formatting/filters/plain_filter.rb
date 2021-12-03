#-- encoding: UTF-8



module ProyeksiApp::TextFormatting
  module Filters
    class PlainFilter < HTML::Pipeline::TextFilter
      include ERB::Util
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::UrlHelper

      def call
        escaped = CGI::escapeHTML(text)
        linked = Rinku.auto_link(escaped, :all)
        simple_format(linked)
      end
    end
  end
end
