#-- encoding: UTF-8



module OpenProject::TextFormatting::Filters::Macros
  module IncludeWikiPage
    HTML_CLASS = 'include_wiki_page'.freeze

    module_function

    def identifier
      HTML_CLASS
    end

    def apply(*)
      raise I18n.t('macros.include_wiki_page.removed')
    end
  end
end
