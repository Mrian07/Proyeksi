

module API
  module V3
    module Meetings
      class MeetingContentsAPI < ::API::ProyeksiAppAPI
        resources :meeting_contents do
          helpers do
            def meeting_content
              MeetingContent.find params[:id]
            end
          end

          route_param :id do
            get do
              ::API::V3::MeetingContents::MeetingContentRepresenter.new(
                meeting_content, current_user: current_user, embed_links: true
              )
            end

            mount ::API::V3::Attachments::AttachmentsByMeetingContentAPI
          end
        end
      end
    end
  end
end
