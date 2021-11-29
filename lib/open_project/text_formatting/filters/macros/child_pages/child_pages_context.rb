#-- encoding: UTF-8



module OpenProject::TextFormatting::Filters::Macros::ChildPages
  class ChildPagesContext
    attr_reader(:page_value, :include_parent, :user, :page)

    def initialize(macro, pipeline_context)
      @page_value = macro['data-page']
      @include_parent = macro['data-include-parent'].to_s == 'true'
      @user = pipeline_context[:current_user]
      @page = fetch_page(pipeline_context)
    end

    def check
      if @page.nil? || !@user.allowed_to?(:view_wiki_pages, @page.wiki.project)
        raise I18n.t('macros.wiki_child_pages.errors.page_not_found', name: @page_value)
      end
    end

    private

    def fetch_page(pipeline_context)
      if page_value.present?
        Wiki.find_page(page_value, project: pipeline_context[:project])
      elsif pipeline_context[:object].is_a?(WikiContent)
        pipeline_context[:object].page
      end
    end
  end
end
