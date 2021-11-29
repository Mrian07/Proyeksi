

module API
  module V3
    module TimeEntries
      class CreateFormAPI < ::API::OpenProjectAPI
        resource :form do
          after_validation do
            authorize :log_time, global: true
          end

          post &::API::V3::Utilities::Endpoints::CreateForm
                  .new(model: TimeEntry)
                  .mount
        end
      end
    end
  end
end
