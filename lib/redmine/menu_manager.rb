#-- encoding: UTF-8



module Redmine::MenuManager
  def self.map(menu_name, &menu_builder)
    @menu_builder_queues ||= {}
    current_queue = @menu_builder_queues[menu_name.to_sym] ||= []

    if menu_builder
      current_queue.push menu_builder
    else
      MapDeferrer.new current_queue
    end
  end

  def self.loose(menu_name, &menu_builder)
    @temp_menu_builder_queues ||= {}
    current_queue = @temp_menu_builder_queues[menu_name.to_sym] ||= []

    if menu_builder
      current_queue.push menu_builder
    else
      MapDeferrer.new current_queue
    end
  end

  def self.items(menu_name)
    items = {}

    mapper = Mapper.new(menu_name.to_sym, items)
    potential_items = @menu_builder_queues[menu_name.to_sym]
    potential_items += @temp_menu_builder_queues[menu_name.to_sym] if @temp_menu_builder_queues and @temp_menu_builder_queues[menu_name.to_sym]

    @temp_menu_builder_queues = {}

    potential_items.each do |menu_builder|
      menu_builder.call(mapper)
    end

    items[menu_name.to_sym] || Redmine::MenuManager::TreeNode.new(:root, {})
  end
end
