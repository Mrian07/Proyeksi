#-- encoding: UTF-8


require 'task_list/filter'

module ProyeksiApp::TextFormatting::Formats::Markdown
  class Formatter < ProyeksiApp::TextFormatting::Formats::BaseFormatter
    def to_html(text)
      result = pipeline.call(text, context)
      output = result[:output].to_s

      output.html_safe
    end

    def to_document(text)
      pipeline.to_document text, context
    end

    def filters
      %i[
        setting_macros
        markdown
        sanitization
        task_list
        table_of_contents
        macro
        mention
        pattern_matcher
        syntax_highlight
        attachment
        relative_link
        link_attribute
        figure_wrapped
        bem_css
        autolink
      ]
    end

    def self.format
      :markdown
    end
  end
end
