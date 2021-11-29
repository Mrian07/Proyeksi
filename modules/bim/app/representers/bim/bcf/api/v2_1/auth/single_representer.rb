#-- encoding: UTF-8



module Bim::Bcf::API::V2_1
  class Auth::SingleRepresenter < BaseRepresenter
    include OpenProject::StaticRouting::UrlHelpers

    property :oauth2_auth_url,
             getter: ->(decorator:, **) {
               "#{decorator.root_url}oauth/authorize"
             }

    property :oauth2_token_url,
             getter: ->(decorator:, **) {
               "#{decorator.root_url}oauth/token"
             }

    property :supported_oauth2_flows,
             getter: ->(*) {
               %w(authorization_code_grant client_credentials)
             }

    property :http_basic_supported,
             getter: ->(*) {
               false
             }
  end
end
