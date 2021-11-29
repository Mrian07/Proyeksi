#-- encoding: UTF-8



module Redmine::MenuManager::WikiMenuHelper
  def build_wiki_menus(project)
    return unless project.enabled_module_names.include? 'wiki'

    project_wiki = project.wiki

    MenuItems::WikiMenuItem.main_items(project_wiki).each do |main_item|
      Redmine::MenuManager.loose :project_menu do |menu|
        push_wiki_main_menu(menu, main_item, project)

        main_item.children.each do |child|
          push_wiki_menu_subitem(menu, main_item, child)
        end
      end
    end
  end

  def push_wiki_main_menu(menu, main_item, project)
    menu.push main_item.menu_identifier,
              { controller: '/wiki', action: 'show', id: main_item.slug },
              caption: main_item.title,
              before: :members,
              icon: 'icon2 icon-wiki',
              html: { class: 'wiki-menu--main-item' }

    if project.wiki.pages.any?
      push_wiki_menu_partial(main_item, menu)
    end
  rescue ArgumentError => e
    Rails.logger.error "Failed to add wiki item #{main_item.slug} to wiki menu: #{e}. Deleting it."
    main_item.destroy
  end

  def push_wiki_menu_subitem(menu, main_item, child)
    menu.push child.menu_identifier,
              { controller: '/wiki', action: 'show', id: child.slug },
              caption: child.title,
              html: { class: 'wiki-menu--sub-item' },
              parent: main_item.menu_identifier
  rescue ArgumentError => e
    Rails.logger.error "Failed to add wiki item #{child.slug} to wiki menu: #{e}. Deleting it."
    child.destroy
  end

  def default_menu_item(page)
    if (main_item = page.nearest_main_item)
      main_item
    else
      MenuItems::WikiMenuItem.main_items(page.wiki.id).first
    end
  end

  private

  def push_wiki_menu_partial(main_item, menu)
    menu.push :wiki_menu_partial,
              { controller: '/wiki', action: 'show' },
              parent: main_item.menu_identifier,
              partial: 'wiki/menu_pages_tree',
              last: true
  end
end
