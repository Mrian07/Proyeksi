

module API
  module V3
    module Users
      class UpdateFormAPI < ::API::OpenProjectAPI
        resource :form do
          after_validation do
            authorize :manage_user, global: true
          end

          post &::API::V3::Utilities::Endpoints::UpdateForm.new(model: User)
                                                           .mount
        end
      end
    end
  end
end
