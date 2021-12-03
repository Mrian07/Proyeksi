module API
  module V3
    module Projects
      class CreateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          after_validation do
            authorize_any %i[add_project add_subprojects], global: true
          end

          post &::API::V3::Utilities::Endpoints::CreateForm.new(model: Project)
                                                           .mount
        end
      end
    end
  end
end
