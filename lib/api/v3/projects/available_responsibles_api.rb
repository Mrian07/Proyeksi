require 'api/v3/users/user_collection_representer'

module API
  module V3
    module Projects
      class AvailableResponsiblesAPI < ::API::ProyeksiAppAPI
        resource :available_responsibles do
          after_validation do
            authorize(:view_work_packages, global: true, user: current_user)
          end

          get &::API::V3::Utilities::Endpoints::Index.new(model: Principal,
                                                          scope: -> {
                                                            Principal.possible_assignee(@project).includes(:preference)
                                                          },
                                                          render_representer: Users::UserCollectionRepresenter)
                                                     .mount
        end
      end
    end
  end
end
