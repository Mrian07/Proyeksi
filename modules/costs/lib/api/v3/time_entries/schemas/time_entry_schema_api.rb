

module API
  module V3
    module TimeEntries
      module Schemas
        class TimeEntrySchemaAPI < ::API::OpenProjectAPI
          resources :schema do
            after_validation do
              authorize_any %i[log_time
                               view_time_entries
                               edit_time_entries
                               edit_own_time_entries],
                            global: true
            end

            get &::API::V3::Utilities::Endpoints::Schema
                   .new(model: TimeEntry)
                   .mount
          end
        end
      end
    end
  end
end
