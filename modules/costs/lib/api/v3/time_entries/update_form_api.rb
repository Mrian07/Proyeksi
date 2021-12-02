

module API
  module V3
    module TimeEntries
      class UpdateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          after_validation do
            authorize_by_with_raise(-> {
              ::TimeEntries::UpdateContract
                .new(@time_entry, current_user)
                .user_allowed_to_update?
            })
          end

          post &::API::V3::Utilities::Endpoints::UpdateForm
                  .new(model: TimeEntry)
                  .mount
        end
      end
    end
  end
end
