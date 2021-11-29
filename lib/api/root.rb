#-- encoding: UTF-8



module API
  class Root < ::API::RootAPI
    content_type 'hal+json', 'application/hal+json; charset=utf-8'
    format 'hal+json'
    formatter 'hal+json', API::Formatter.new
    default_format 'hal+json'

    parser :json, API::V3::Parser.new

    error_representer ::API::V3::Errors::ErrorRepresenter, 'hal+json'
    authentication_scope OpenProject::Authentication::Scope::API_V3

    OpenProject::Authentication.handle_failure(scope: API_V3) do |warden, _opts|
      e = grape_error_for warden.env, self
      error_message = I18n.t('api_v3.errors.code_401_wrong_credentials')
      api_error = ::API::Errors::Unauthenticated.new error_message
      representer = ::API::V3::Errors::ErrorRepresenter.new api_error

      e.error_response status: 401, message: representer.to_json, headers: warden.headers, log: false
    end

    version 'v3', using: :path do
      mount API::V3::Root
    end
  end
end
