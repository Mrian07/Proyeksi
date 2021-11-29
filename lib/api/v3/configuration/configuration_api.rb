

require 'api/v3/configuration/configuration_representer'

module API
  module V3
    module Configuration
      class ConfigurationAPI < ::API::OpenProjectAPI
        resources :configuration do
          get do
            ConfigurationRepresenter.new(Setting, current_user: current_user, embed_links: true)
          end
        end
      end
    end
  end
end
