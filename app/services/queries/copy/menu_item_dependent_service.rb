#-- encoding: UTF-8

module Queries::Copy
  class MenuItemDependentService < ::Copy::Dependency
    protected

    def copy_dependency(params:)
      duplicate_query_menu_item(source, target)
    end

    def duplicate_query_menu_item(query, new_query)
      if query.query_menu_item && new_query.persisted?
        ::MenuItems::QueryMenuItem.create(
          navigatable_id: new_query.id,
          name: SecureRandom.uuid,
          title: query.query_menu_item.title
        )
      end
    end
  end
end
