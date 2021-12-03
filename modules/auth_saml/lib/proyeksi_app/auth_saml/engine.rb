require 'omniauth-saml'
module ProyeksiApp
  module AuthSaml
    def self.configuration
      RequestStore.fetch(:proyeksiapp_omniauth_saml_provider) do
        @saml_settings ||= load_global_settings!
        @saml_settings.deep_merge(settings_from_db)
      end
    end

    def self.reload_configuration!
      @saml_settings = nil
      RequestStore.delete :proyeksiapp_omniauth_saml_provider
    end

    ##
    # Loads the settings once to avoid accessing the file in each request
    def self.load_global_settings!
      Hash(settings_from_config || settings_from_yaml).with_indifferent_access
    end

    def self.settings_from_db
      value = Hash(Setting.plugin_proyeksiapp_auth_saml).with_indifferent_access[:providers]

      value.is_a?(Hash) ? value : {}
    end

    def self.settings_from_config
      if ProyeksiApp::Configuration['saml'].present?
        Rails.logger.info("[auth_saml] Registering saml integration from configuration.yml")

        ProyeksiApp::Configuration['saml']
      end
    end

    def self.settings_from_yaml
      if (settings = Rails.root.join('config', 'plugins', 'auth_saml', 'settings.yml')).exist?
        Rails.logger.info("[auth_saml] Registering saml integration from settings file")

        YAML::load(File.open(settings)).symbolize_keys
      end
    end

    class Engine < ::Rails::Engine
      engine_name :proyeksiapp_auth_saml

      include ProyeksiApp::Plugins::ActsAsOpEngine
      extend ProyeksiApp::Plugins::AuthPlugin

      register 'proyeksiapp-auth_saml',
               author_url: 'https://github.com/finnlabs/proyeksiapp-auth_saml',
               bundled: true,
               settings: { default: { "providers" => nil } }

      assets %w(
        auth_saml/**
        auth_provider-saml.png
      )

      register_auth_providers do
        strategy :saml do
          ProyeksiApp::AuthSaml.configuration.values.map do |h|
            # Remember saml session values when logging in user
            h[:retain_from_session] = %w[saml_uid saml_session_index saml_transaction_id]

            h[:single_sign_out_callback] = Proc.new do |prev_session, _prev_user|
              next unless h[:idp_slo_target_url]
              next unless prev_session[:saml_uid] && prev_session[:saml_session_index]

              # Set the uid and index for the logout in this session again
              session.merge! prev_session.slice(*h[:retain_from_session])

              redirect_to omniauth_start_path(h[:name]) + "/spslo"
            end

            h[:proyeksiapp_attribute_map] = Proc.new do |auth|
              {}.tap do |additional|
                additional[:login] = auth.info[:login] if auth.info.key? :login
                additional[:admin] = auth.info[:admin] if auth.info.key? :admin
              end
            end
            h.symbolize_keys
          end
        end
      end
    end
  end
end
