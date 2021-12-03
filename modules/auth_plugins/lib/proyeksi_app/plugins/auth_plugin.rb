#-- encoding: UTF-8



module ProyeksiApp::Plugins
  module AuthPlugin
    def register_auth_providers(&build_providers)
      initializer "#{engine_name}.middleware" do |app|
        builder = ProviderBuilder.new
        builder.instance_eval(&build_providers)

        app.config.middleware.use OmniAuth::FlexibleBuilder do
          builder.new_strategies.each do |strategy|
            provider strategy
          end
        end
      end
    end

    def self.strategies
      @strategies ||= {}
    end

    def self.providers_for(strategy)
      matching = Array(strategies[strategy_key(strategy)])
      filtered_strategies matching.map(&:call).flatten.map(&:to_hash)
    end

    def self.login_provider_for(user)
      return unless user.identity_url

      provider_name = user.identity_url.split(':').first
      find_provider_by_name(provider_name)
    end

    def self.find_provider_by_name(provider_name)
      providers.detect { |hash| hash[:name].to_s == provider_name.to_s }
    end

    def self.providers
      RequestStore.fetch(:proyeksiapp_omniauth_filtered_strategies) do
        filtered_strategies strategies.values.flatten.map(&:call).flatten.map(&:to_hash)
      end
    end

    def self.filtered_strategies(options)
      options.select do |provider|
        name = provider[:name]&.to_s
        next true if !EnterpriseToken.show_banners? || name == 'developer'

        warn_unavailable(name)

        false
      end
    end

    def self.strategy_key(strategy)
      return strategy if strategy.is_a? Symbol
      return strategy.to_sym if strategy.is_a? String

      name = strategy.name.demodulize
      camelization = OmniAuth.config.camelizations.select do |_k, v|
        v == name
      end.take(1).map do |k, _v|
        k
      end.first

      [camelization, name].compact.first.underscore.to_sym
    end

    def self.warn_unavailable(name)
      RequestStore.fetch("warn_unavailable_auth_#{name}") do
        Rails.logger.warn { "OmniAuth SSO strategy #{name} is only available for Enterprise Editions." }
        true
      end
    end
  end

  class ProviderBuilder
    def strategy(strategy, &providers)
      key = AuthPlugin.strategy_key(strategy)

      if AuthPlugin.strategies.include? key
        AuthPlugin.strategies[key] << providers
      else
        AuthPlugin.strategies[key] = [providers]
        new_strategies << strategy
      end
    end

    def new_strategies
      @new_strategies ||= []
    end
  end
end
