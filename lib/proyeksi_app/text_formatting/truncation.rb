#-- encoding: UTF-8



module ProyeksiApp
  module TextFormatting
    module Truncation
      # Used for truncation
      include ActionView::Helpers::TextHelper

      # Truncates and returns the string as a single line
      def truncate_single_line(string, *args)
        truncate(string.to_s, *args).gsub(%r{[\r\n]+}m, ' ').html_safe
      end

      # Truncates at line break after 250 characters or options[:length]
      def truncate_lines(string, options = {})
        length = options[:length] || 250
        if string.to_s =~ /\A(.{#{length}}.*?)$/m
          "#{$1}..."
        else
          string
        end
      end
    end
  end
end
