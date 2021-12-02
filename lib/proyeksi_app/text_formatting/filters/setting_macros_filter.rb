#-- encoding: UTF-8



module ProyeksiApp::TextFormatting
  module Filters
    class SettingMacrosFilter < HTML::Pipeline::Filter
      ALLOWED_SETTINGS = %w[
        host_name
        base_url
      ].freeze

      def self.regexp
        %r{
        \{\{opSetting:(.+?)\}\}
        }x
      end

      def call
        return html unless applicable?

        html.gsub(self.class.regexp) do |matched_string|
          variable = $1.to_s
          variable.gsub!('\\', '')

          if ALLOWED_SETTINGS.include?(variable)
            send variable
          else
            matched_string
          end
        end
      end

      private

      def host_name
        ProyeksiApp::StaticRouting::UrlHelpers.host
      end

      def base_url
        ProyeksiApp::Application.root_url
      end

      ##
      # Faster inclusion check before the regex is being applied
      def applicable?
        html.include?('{{opSetting:')
      end
    end
  end
end
