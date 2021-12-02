#-- encoding: UTF-8



module ProyeksiApp::TextFormatting::Filters::Macros
  module ChildPages
    HTML_CLASS = 'child_pages'.freeze

    module_function

    def identifier
      HTML_CLASS
    end

    def apply(macro, context:, **_args)
      insert_child_pages(macro, context) if is?(macro)
    end

    def insert_child_pages(macro, pipeline_context)
      context = ChildPagesContext.new(macro, pipeline_context)
      context.check

      macro.replace(render_tree(context.include_parent, context.page))
    end

    def is?(macro)
      macro['class'].include?(HTML_CLASS)
    end

    def render_tree(include_parent, page)
      pages = ([page] + page.descendants).group_by(&:parent_id)
      ApplicationController.helpers.render_page_hierarchy(pages, include_parent ? page.parent_id : page.id)
    end
  end
end
