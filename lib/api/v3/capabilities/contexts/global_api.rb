

module API
  module V3
    module Capabilities
      module Contexts
        class GlobalAPI < ::API::ProyeksiAppAPI
          resources :global do
            get do
              Contexts::GlobalRepresenter.create(nil,
                                                 current_user: current_user)
            end
          end
        end
      end
    end
  end
end
