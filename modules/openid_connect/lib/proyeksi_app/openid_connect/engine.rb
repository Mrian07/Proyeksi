require 'proyeksi_app/plugins'

module ProyeksiApp::OpenIDConnect
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_openid_connect

    include ProyeksiApp::Plugins::ActsAsOpEngine
    extend ProyeksiApp::Plugins::AuthPlugin

    register 'proyeksiapp-openid_connect',
             author_url: 'https://www.proyeksiapp.org',
             bundled: true,
             settings: { 'default' => { 'providers' => {} } } do
      menu :admin_menu,
           :plugin_openid_connect,
           :openid_connect_providers_path,
           parent: :authentication,
           caption: ->(*) { I18n.t('openid_connect.menu_title') }
    end

    assets %w(
      openid_connect/auth_provider-azure.png
      openid_connect/auth_provider-google.png
      openid_connect/auth_provider-heroku.png
    )

    class_inflection_override('openid_connect' => 'OpenIDConnect')

    register_auth_providers do
      # Use OpenSSL default certificate store instead of HTTPClient's.
      # It's outdated and it's unclear how it's managed.
      OpenIDConnect.http_config do |config|
        config.ssl_config.set_default_paths
      end

      OmniAuth::OpenIDConnect::Providers.configure custom_options: %i[
        display_name? icon? sso? issuer?
        check_session_iframe? end_session_endpoint?
      ]

      strategy :openid_connect do
        ProyeksiApp::OpenIDConnect.providers.map(&:to_h)
      end
    end

    initializer 'openid_connect.form_post_method' do
      # If response_mode 'form_post' is chosen,
      # the IP sends a POST to the callback. Only if
      # the sameSite flag is not set on the session cookie, is the cookie send along with the request.
      if ProyeksiApp::Configuration['openid_connect']&.any? { |_, v| v['response_mode']&.to_s == 'form_post' }
        SecureHeaders::Configuration.default.cookies[:samesite][:lax] = false
        # Need to reload the secure_headers config to
        # avoid having set defaults (e.g. https) when changing the cookie values
        load Rails.root + 'config/initializers/secure_headers.rb'
      end
    end

    config.to_prepare do
      # set a secure cookie in production
      secure_cookie = !!Rails.configuration.force_ssl

      # register an #after_login callback which sets a cookie containing the access token
      ProyeksiApp::OmniAuth::Authorization.after_login do |_user, auth_hash, context|
        # check the configuration
        if store_access_token?
          # fetch the access token if it's present
          access_token = auth_hash.fetch(:credentials, {})[:token]
          # put it into a cookie
          if context && access_token
            controller = context.controller
            controller.send(:cookies)[:_proyeksi_app_session_access_token] = {
              value: access_token,
              secure: secure_cookie
            }
          end
        end
      end

      # for changing the setting at runtime, e.g. for testing, we need to evaluate this each time
      def self.store_access_token?
        # TODO: we might want this to be configurable, for now we always enable it
        # ProyeksiApp::Configuration['omniauth_store_access_token_in_cookie']
        true
      end
    end
  end
end
