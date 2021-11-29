

module API
  module V3
    module Projects
      class UpdateFormAPI < ::API::OpenProjectAPI
        resource :form do
          after_validation do
            authorize :edit_project, context: @project
          end

          post &::API::V3::Utilities::Endpoints::UpdateForm.new(model: Project)
                                                           .mount
        end
      end
    end
  end
end
