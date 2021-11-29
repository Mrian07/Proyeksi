#-- encoding: UTF-8



module OpenProject::TextFormatting::Filters::Macros
  module EmbeddedTable
    HTML_CLASS = 'embedded-table'.freeze

    module_function

    def identifier
      HTML_CLASS
    end

    def apply(macro, result:, context:)
      macro['class'] = macro['class'].gsub('op-uc-placeholder', '').squish
    end

    def is?(macro)
      macro['class'].include?(HTML_CLASS)
    end
  end
end
