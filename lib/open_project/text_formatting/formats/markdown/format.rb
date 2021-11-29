#-- encoding: UTF-8



module OpenProject::TextFormatting::Formats::Markdown
  class Format < OpenProject::TextFormatting::Formats::BaseFormat
    class << self
      def format
        :markdown
      end

      def priority
        5
      end
    end
  end
end
