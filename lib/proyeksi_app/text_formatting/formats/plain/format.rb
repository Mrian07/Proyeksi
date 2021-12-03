#-- encoding: UTF-8



module ProyeksiApp::TextFormatting::Formats::Plain
  class Format < ProyeksiApp::TextFormatting::Formats::BaseFormat
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
