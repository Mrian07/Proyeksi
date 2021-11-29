#-- encoding: UTF-8



module OpenProject::TextFormatting
  class Renderer
    class << self
      def format_text(text, options = {})
        return '' if text.blank?

        formatter(plain: options.delete(:plain))
          .new(options)
          .to_html(text)
      end

      def formatter(plain: false)
        if plain
          OpenProject::TextFormatting::Formats.plain_formatter
        else
          OpenProject::TextFormatting::Formats.rich_formatter
        end
      end
    end
  end
end
