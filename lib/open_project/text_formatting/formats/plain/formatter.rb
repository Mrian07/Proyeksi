#-- encoding: UTF-8



module OpenProject::TextFormatting::Formats
  module Plain
    class Formatter < OpenProject::TextFormatting::Formats::BaseFormatter
      def to_html(text)
        pipeline.to_html(text, context).html_safe
      end

      def to_document(text)
        pipeline.to_document text, context
      end

      def filters
        %i(plain setting_macros pattern_matcher)
      end

      def self.format
        :plain
      end
    end
  end
end
