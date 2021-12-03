#-- encoding: UTF-8



module API
  module V3
    module StringObjects
      class StringObjectsAPI < ::API::ProyeksiAppAPI
        resources :string_objects do
          params do
            requires :value, type: String
          end

          get do
            status :gone
          end
        end
      end
    end
  end
end
