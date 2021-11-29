#-- encoding: UTF-8



module QueryMenuItemsHelper
  def update_query_menu_item_path(project, query_menu_item)
    if query_menu_item.persisted?
      query_menu_item_path(project, query_menu_item.query,
                           query_menu_item)
    else
      query_menu_items_path(project, query_menu_item.query)
    end
  end
end
