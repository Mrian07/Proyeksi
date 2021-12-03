#-- encoding: UTF-8

module WikiHelper
  def wiki_page_options_for_select(pages,
                                   ids: true,
                                   placeholder: true)
    s = if placeholder
          [["-- #{t('label_no_parent_page')} --", '']]
        else
          []
        end

    s + wiki_page_options_for_select_of_level(pages.group_by(&:parent),
                                              ids: ids)
  end

  def breadcrumb_for_page(page, action = nil)
    related_pages = page.ancestors.reverse

    if action
      related_pages += [page]
    end

    paths = related_pages.map { |parent| link_to h(parent.breadcrumb_title), project_wiki_path(parent, parent.project) }

    paths += if action
               [action]
             else
               [h(page.breadcrumb_title)]
             end

    breadcrumb_paths(*paths)
  end

  def nl2br(content)
    content.gsub(/(?:\n\r?|\r\n?)/, '<br />').html_safe
  end

  private

  def wiki_page_options_for_select_of_level(pages,
                                            parent: nil,
                                            level: 0,
                                            ids: true)
    return [] unless pages[parent]

    pages[parent].inject([]) do |s, page|
      s << wiki_page_option(page, level, ids)
      s += wiki_page_options_for_select_of_level(pages, parent: page, level: level + 1, ids: ids)
      s
    end
  end

  def wiki_page_option(page, level, ids)
    indent = level.positive? ? ('&nbsp;' * level * 2 + '&#187; ') : ''
    id = ids ? page.id : page.title
    [(indent + h(page.title)).html_safe, id]
  end
end
