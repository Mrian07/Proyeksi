#-- encoding: UTF-8



module OpenProject::TextFormatting::Filters::Macros
  module Toc
    HTML_CLASS = 'toc'.freeze

    module_function

    def identifier
      HTML_CLASS
    end

    def apply(macro, result:, context:)
      raise 'The HTML::Pipeline::TableOfContentsFilters needs to run before.' unless result[:toc]

      macro.replace(result[:toc])
    end
  end
end
