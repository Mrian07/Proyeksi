#-- encoding: UTF-8



module ProyeksiApp::TextFormatting
  module Filters
    class MarkdownFilter < HTML::Pipeline::MarkdownFilter
      # Convert Markdown to HTML using CommonMarker
      def call
        render_html parse
      end

      private

      ##
      # Get initial CommonMarker AST for further processing
      #
      def parse
        parse_options = %i[LIBERAL_HTML_TAG STRIKETHROUGH_DOUBLE_TILDE UNSAFE]

        # We need liberal html tags thus parsing and rendering are several steps
        # Check: We may be able to reuse the ast instead of rendering to html and then parsing with nokogiri again.
        CommonMarker.render_doc(
          text,
          parse_options,
          commonmark_extensions
        )
      end

      ##
      # Render the transformed AST
      def render_html(ast)
        render_options = %i[GITHUB_PRE_LANG UNSAFE]
        render_options << :HARDBREAKS if context[:gfm] != false

        ast
          .to_html(render_options, commonmark_extensions)
          .tap(&:rstrip!)
      end

      ##
      # Extensions to the default CommonMarker operation
      def commonmark_extensions
        context.fetch :commonmarker_extensions, %i[table strikethrough tagfilter]
      end
    end
  end
end
