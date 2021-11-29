#-- encoding: UTF-8



module Grids::Configuration
  class << self
    def register_grid(grid,
                      klass)
      grid_register[grid] = klass
    end

    def registered_grids
      if @registered_grid_classes && @registered_grid_classes.length == grid_register.length
        @registered_grid_classes
      else
        @registered_grid_classes = grid_register.keys.map(&:constantize)
      end
    end

    def all_scopes
      all.map(&:all_scopes).flatten.compact
    end

    def writable_scopes
      all.map(&:writable_scopes).flatten.compact
    end

    def all
      grid_register.values
    end

    def attributes_from_scope(page)
      config = all.find do |config|
        config.from_scope(page)
      end

      if config
        config.from_scope(page)
      else
        { class: ::Grids::Grid }
      end
    end

    def defaults(klass)
      grid_register[klass.name]&.defaults
    end

    def class_from_scope(page)
      attributes_from_scope(page)[:class]
    end

    def to_scope(klass, path_parts)
      config = grid_register[klass.name]

      return nil unless config

      url_helpers.send(config.to_scope, path_parts)
    end

    def registered_grid?(klass)
      registered_grids.include? klass
    end

    def register_widget(identifier, grid_classes)
      @widget_register ||= {}

      @widget_register[identifier] ||= []

      @widget_register[identifier] += Array(grid_classes)
    end

    def allowed_widget?(grid, identifier, user, project)
      grid_classes = registered_widget_by_identifier[identifier]

      (grid_classes || []).include?(grid) &&
        widget_strategy(grid, identifier)&.allowed?(user, project)
    end

    def all_widget_identifiers(grid)
      registered_widget_by_identifier.select do |_, grid_classes|
        grid_classes.include?(grid)
      end.keys
    end

    def widget_strategy(grid, identifier)
      grid_register[grid.to_s]&.widget_strategy(identifier) || Grids::Configuration::WidgetStrategy
    end

    ##
    # Determines whether the given scope is writable by the current user
    def writable_scope?(scope)
      writable_scopes.include? scope
    end

    ##
    # Determine whether the given grid is writable
    #
    # @param grid Either a grid instance, or the grid class namespace (e.g., Grids::Grid)
    # @param user the current user to check against
    def writable?(grid, user)
      grid_register[grid.class.to_s]&.writable?(grid, user)
    end

    def validations(grid, mode)
      grid_register[grid.class.to_s]&.validations(mode) || []
    end

    protected

    def grid_register
      @grid_register ||= {}
    end

    def registered_widget_by_identifier
      if @registered_widget_by_identifier && @registered_widget_by_identifier.length == @widget_register.length
        @registered_widget_by_identifier
      else
        @registered_widget_by_identifier = @widget_register
                                           .map { |identifier, classes| [identifier, classes.map(&:constantize)] }
                                           .to_h
      end
    end

    def url_helpers
      @url_helpers ||= OpenProject::StaticRouting::StaticUrlHelpers.new
    end
  end
end