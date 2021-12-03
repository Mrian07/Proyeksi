#-- encoding: UTF-8



module ProyeksiApp::TextFormatting::Formats::Markdown
  class Format < ProyeksiApp::TextFormatting::Formats::BaseFormat
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
