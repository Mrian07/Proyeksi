#-- encoding: UTF-8



module API
  module Utilities
    class TextRenderer
      include ActionView::Helpers::UrlHelper
      include ProyeksiApp::StaticRouting::UrlHelpers
      include ProyeksiApp::TextFormatting
      include WorkPackagesHelper

      def initialize(text, format: nil, object: nil)
        @text = text
        @format = format
        @object = object
        if object.respond_to?(:project)
          @project = object.project
        elsif @object.is_a?(Project)
          @project = object
        end
      end

      def to_html
        format_text(@text, format: @format, object: @object, project: @project)
      end

      def controller; end
    end
  end
end
