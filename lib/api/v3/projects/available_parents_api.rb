

require 'api/v3/users/user_collection_representer'

module API
  module V3
    module Projects
      class AvailableParentsAPI < ::API::ProyeksiAppAPI
        resource :available_parent_projects do
          after_validation do
            authorize_any(%i[add_project add_subprojects edit_project], global: true)
          end

          get &::API::V3::Utilities::Endpoints::Index.new(model: Project,
                                                          scope: -> do
                                                            project = if params[:of]
                                                                        Project.find(params[:of])
                                                                      else
                                                                        Project.new
                                                                      end

                                                            contract_class = if project.new_record?
                                                                               ::Projects::CreateContract
                                                                             else
                                                                               ::Projects::UpdateContract
                                                                             end

                                                            contract = contract_class.new(project, current_user)

                                                            contract.assignable_parents.includes(:enabled_modules)
                                                          end)
                                                     .mount
        end
      end
    end
  end
end
