#-- encoding: UTF-8



require 'proyeksi_app/plugins/auth_plugin'

module OmniAuth
  module FlexibleStrategy
    def on_auth_path?
      possible_auth_path? && (match_provider! || false) && super
    end

    ##
    # Tries to match the request path of the current request with one of the registered providers.
    # If a match is found the strategy is initialised with that provider to handle the request.
    def match_provider!
      return false unless providers

      @provider = providers.find do |p|
        (current_path =~ /#{path_for_provider(p.to_hash[:name])}/) == 0
      end

      if @provider
        options.merge! provider.to_hash
      end

      @provider
    end

    def omniauth_hash_to_user_attributes(auth)
      if options.key?(:proyeksiapp_attribute_map)
        options[:proyeksiapp_attribute_map].call(auth)
      else
        {}
      end
    end

    def path_for_provider(name)
      "#{script_name}#{path_prefix}/#{name}"
    end

    ##
    # Returns true if the current path could be an authentication request,
    # false otherwise (e.g. for resources).
    def possible_auth_path?
      current_path =~ /\A#{script_name}#{path_prefix}/
    end

    def providers
      @providers ||= ProyeksiApp::Plugins::AuthPlugin.providers_for(self.class)
    end

    def provider
      @provider
    end

    def providers=(providers)
      @providers = providers
    end

    def dup
      super.tap do |s|
        s.extend FlexibleStrategy
      end
    end
  end

  module FlexibleStrategyClass
    def new(app, *args, &block)
      super(app, *args, &block).tap do |strategy|
        strategy.extend FlexibleStrategy
      end
    end
  end
end
