

module API
  module V3
    module TimeEntries
      class TimeEntriesAPI < ::API::OpenProjectAPI
        helpers ::API::Utilities::PageSizeHelper

        resources :time_entries do
          get &::API::V3::Utilities::Endpoints::Index.new(model: TimeEntry).mount
          post &::API::V3::Utilities::Endpoints::Create.new(model: TimeEntry).mount

          mount ::API::V3::TimeEntries::CreateFormAPI
          mount ::API::V3::TimeEntries::Schemas::TimeEntrySchemaAPI
          mount ::API::V3::TimeEntries::AvailableProjectsAPI
          mount ::API::V3::TimeEntries::AvailableWorkPackagesOnCreateAPI

          route_param :id, type: Integer, desc: 'Time entry ID' do
            after_validation do
              @time_entry = TimeEntry
                            .visible
                            .find(params[:id])
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: TimeEntry).mount
            patch &::API::V3::Utilities::Endpoints::Update.new(model: TimeEntry).mount
            delete &::API::V3::Utilities::Endpoints::Delete.new(model: TimeEntry).mount

            mount ::API::V3::TimeEntries::UpdateFormAPI
            mount ::API::V3::TimeEntries::AvailableWorkPackagesOnEditAPI
          end

          mount ::API::V3::TimeEntries::TimeEntriesActivityAPI
        end
      end
    end
  end
end
