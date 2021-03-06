#-- encoding: UTF-8



module ProyeksiApp::TextFormatting::Formats
  class BaseFormat
    class << self
      def format
        raise NotImplementedError
      end

      def priority
        raise NotImplementedError
      end

      def helper
        @helper = "ProyeksiApp::TextFormatting::Formats::#{format.to_s.camelcase}::Helper".constantize
      end

      def formatter
        @formatter ||= "ProyeksiApp::TextFormatting::Formats::#{format.to_s.camelcase}::Formatter".constantize
      end

      def setup
        # Force lookup to avoid const errors later on.
        helper and formatter
      rescue NameError => e
        Rails.logger.error "Failed to register wiki formatting #{format}: #{e}"
        Rails.logger.debug { e.backtrace }
      end
    end
  end
end
