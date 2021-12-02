require 'proyeksi_app/authentication'

# Strategies provided by ProyeksiApp:
require 'proyeksi_app/authentication/strategies/warden/basic_auth_failure'
require 'proyeksi_app/authentication/strategies/warden/global_basic_auth'
require 'proyeksi_app/authentication/strategies/warden/user_basic_auth'
require 'proyeksi_app/authentication/strategies/warden/doorkeeper_oauth'
require 'proyeksi_app/authentication/strategies/warden/session'

WS = ProyeksiApp::Authentication::Strategies::Warden

strategies = [
  [:basic_auth_failure, WS::BasicAuthFailure,  'Basic'],
  [:global_basic_auth,  WS::GlobalBasicAuth,   'Basic'],
  [:user_basic_auth,    WS::UserBasicAuth,     'Basic'],
  [:oauth,              WS::DoorkeeperOAuth,   'OAuth'],
  [:anonymous_fallback, WS::AnonymousFallback, 'Basic'],
  [:session,            WS::Session,           'Session']
]

strategies.each do |name, clazz, auth_scheme|
  ProyeksiApp::Authentication.add_strategy name, clazz, auth_scheme
end

include ProyeksiApp::Authentication::Scope

api_v3_options = {
  store: false
}
ProyeksiApp::Authentication.update_strategies(API_V3, api_v3_options) do |_strategies|
  %i[global_basic_auth user_basic_auth basic_auth_failure oauth session anonymous_fallback]
end
