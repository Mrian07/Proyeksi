#-- encoding: UTF-8



module Redmine::MenuManager::MenuController
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    @@menu_items = Hash.new { |hash, key| hash[key] = { default: key, actions: {} } }
    mattr_accessor :menu_items

    # Set the menu item name for a controller or specific actions
    # Examples:
    #   * menu_item :tickets # => sets the menu name to :tickets for the whole controller
    #   * menu_item :tickets, only: :list # => sets the menu name to :tickets for the 'list' action only
    #   * menu_item :tickets, only: [:list, :show] # => sets the menu name to :tickets for 2 actions only
    #
    # The default menu item name for a controller is controller_path by default
    # Eg. the default menu item name for ProjectsController is :projects
    def menu_item(id, options = {})
      if actions = options[:only]
        actions = [] << actions unless actions.is_a?(Array)
        actions.each { |a| menu_items[controller_path.to_sym][:actions][a.to_sym] = id }
      else
        menu_items[controller_path.to_sym][:default] = id
      end
    end

    def current_menu_item(actions = :default, &block)
      raise ArgumentError '#current_menu_item requires a block' unless block_given?

      if actions == :default
        menu_items[controller_path.to_sym][:default] = block
      else
        actions = [] << actions unless actions.is_a?(Array)
        actions.each { |a| menu_items[controller_path.to_sym][:actions][a.to_sym] = block }
      end
    end
  end

  def menu_items
    self.class.menu_items
  end

  # Returns the menu item name according to the current action
  def current_menu_item
    return @current_menu_item if @current_menu_item_determined

    @current_menu_item = menu_items[controller_path.to_sym][:actions][action_name.to_sym] ||
                         menu_items[controller_path.to_sym][:default]

    @current_menu_item = if @current_menu_item.is_a?(Symbol)
                           @current_menu_item
                         elsif @current_menu_item.is_a?(Proc)
                           @current_menu_item.call(self)
                         else
                           raise ArgumentError 'Invalid'
                         end

    @current_menu_item_determined = true

    @current_menu_item
  end

  # Redirects user to the menu item of the given project
  # Returns false if user is not authorized
  def redirect_to_project_menu_item(project, name)
    item = project_menu_item(name)
    if user_allowed_to_access_item?(project, item)
      engine = item.engine ? send(item.engine) : main_app

      redirect_to(engine.url_for({ item.param => project }.merge(item.url(project))))
      return true
    end
    false
  end

  def project_menu_item(name)
    Redmine::MenuManager.items(:project_menu).detect { |i| i.name.to_s == name.to_s }
  end

  def admin_menu_item(name)
    Redmine::MenuManager.items(:admin_menu).detect { |i| i.name.to_s == name.to_s }
  end

  def user_allowed_to_access_item?(project, item)
    item && User.current.allowed_to?(item.url(project), project) && (item.condition.nil? || item.condition.call(project))
  end
end
