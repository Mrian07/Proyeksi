

module API
  module V3
    module Actions
      class ActionsAPI < ::API::ProyeksiAppAPI
        resources :actions do
          get &API::V3::Utilities::Endpoints::SqlIndex
                 .new(model: Action)
                 .mount

          params do
            requires :id, type: String, desc: 'The action identifier'
          end
          namespace '*id' do
            get &API::V3::Utilities::Endpoints::SqlShow
                   .new(model: Action)
                   .mount
          end
        end
      end
    end
  end
end
