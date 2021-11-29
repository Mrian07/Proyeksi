#-- encoding: UTF-8



module OpenProject::TextFormatting
  module Filters
    class SyntaxHighlightFilter < HTML::Pipeline::SyntaxHighlightFilter
      def initialize(*args)
        super(*args)

        @formatter = highlighter_class
      end

      ##
      # Get highlighter class for the current context
      def highlighter_class
        # Get syntax highlighting options. If we're in a CSS-constrained environment (i.e., mail),
        # inline syntax highlighting.
        if context[:inline_css]
          Rouge::Formatters::HTMLInline.new Rouge::Themes::Github
        else
          Rouge::Formatters::HTML.new
        end
      end
    end
  end
end
