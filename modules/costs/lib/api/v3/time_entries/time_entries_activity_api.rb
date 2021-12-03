

module API
  module V3
    module TimeEntries
      class TimeEntriesActivityAPI < ::API::ProyeksiAppAPI
        resources :activities do
          route_param :id, type: Integer, desc: 'Time entry activity ID' do
            after_validation do
              authorize_any(%i(log_time
                               view_time_entries
                               edit_time_entries
                               edit_own_time_entries
                               manage_project_activities), global: true) do
                raise API::Errors::NotFound.new
              end

              @activity = TimeEntryActivity
                          .shared
                          .find(params[:id])
            end

            get do
              TimeEntriesActivityRepresenter.new(@activity,
                                                 current_user: current_user,
                                                 embed_links: true)
            end
          end
        end
      end
    end
  end
end
