#-- encoding: UTF-8



module ProyeksiApp::CustomStyles
  class Design
    ##
    # Returns the name of the color scheme.
    # To be overridden by a plugin
    def self.name
      'ProyeksiApp Theme'
    end

    def self.identifier
      :core_design
    end

    def self.overridden?
      identifier == :core_design
    end

    ##
    # Path the favicon
    def self.favicon_asset_path
      'favicon.ico'.freeze
    end

    ##
    # Returns the keys of variables that are customizable through the design
    def self.customizable_variables
      %w( primary-color
          primary-color-dark
          alternative-color
          content-link-color
          header-bg-color
          header-item-bg-hover-color
          header-item-font-color
          header-item-font-hover-color
          header-border-bottom-color
          main-menu-bg-color
          main-menu-bg-selected-background
          main-menu-bg-hover-background
          main-menu-font-color
          main-menu-selected-font-color
          main-menu-hover-font-color
          main-menu-border-color )
    end
  end
end
