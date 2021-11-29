

module API
  module V3
    module Capabilities
      class CapabilitiesAPI < ::API::OpenProjectAPI
        resources :capabilities do
          get &API::V3::Utilities::Endpoints::SqlIndex
                 .new(model: Capability)
                 .mount

          namespace :contexts do
            mount API::V3::Capabilities::Contexts::GlobalAPI
          end

          params do
            requires :id, type: String, desc: 'The capability identifier'
          end
          namespace '*id' do
            get &API::V3::Utilities::Endpoints::SqlShow
                   .new(model: Capability)
                   .mount
          end
        end
      end
    end
  end
end
