require 'api/v3/activities/activity_representer'

module API
  module V3
    module Activities
      class ActivitiesByWorkPackageAPI < ::API::ProyeksiAppAPI
        resource :activities do
          get do
            self_link = api_v3_paths.work_package_activities @work_package.id
            journals = @work_package.journals.includes(:data,
                                                       :customizable_journals,
                                                       :attachable_journals,
                                                       :bcf_comment)

            Activities::ActivityCollectionRepresenter.new(journals,
                                                          self_link: self_link,
                                                          current_user: current_user)
          end

          params do
            requires :comment, type: Hash
          end
          post do
            authorize({ controller: :journals, action: :new }, context: @work_package.project) do
              raise ::API::Errors::NotFound.new
            end

            result = AddWorkPackageNoteService
                       .new(user: current_user,
                            work_package: @work_package)
                       .call(params[:comment][:raw],
                             send_notifications: !(params.has_key?(:notify) && params[:notify] == 'false'))

            if result.success?
              Activities::ActivityRepresenter.new(work_package.journals.last, current_user: current_user)
            else
              fail ::API::Errors::ErrorBase.create_and_merge_errors(result.errors)
            end
          end
        end
      end
    end
  end
end
