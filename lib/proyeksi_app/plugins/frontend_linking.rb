

module ::ProyeksiApp::Plugins
  module FrontendLinking
    ##
    # Register plugins with an Angular frontend to the CLI build.
    # For that, search all gems with the group :opf_plugins
    def self.regenerate!
      Generator.new.regenerate!
    end
  end
end
