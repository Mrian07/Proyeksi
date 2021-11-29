#-- encoding: UTF-8



module OpenProject::TextFormatting::Formats::Plain
  class Format < OpenProject::TextFormatting::Formats::BaseFormat
    class << self
      def format
        :plain
      end

      def priority
        100
      end
    end
  end
end
