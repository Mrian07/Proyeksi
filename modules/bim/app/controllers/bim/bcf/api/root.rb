#-- encoding: UTF-8



# Root class of the API
# This is the place for all API wide configuration, helper methods, exceptions
# rescuing, mounting of different API versions etc.

module Bim::Bcf
  module API
    class Root < ::API::RootAPI
      format :json
      formatter :json, ::API::Formatter.new

      default_format :json

      error_representer ::Bim::Bcf::API::V2_1::Errors::ErrorRepresenter, :json
      error_formatter :json, ::Bim::Bcf::API::ErrorFormatter::Json

      authentication_scope OpenProject::Authentication::Scope::BCF_V2_1

      version '2.1', using: :path do
        # /auth
        mount ::Bim::Bcf::API::V2_1::AuthAPI
        # /current-user
        mount ::Bim::Bcf::API::V2_1::CurrentUserAPI
        # /projects
        mount ::Bim::Bcf::API::V2_1::ProjectsAPI
      end
    end
  end
end
