#-- encoding: UTF-8



module API
  module V3
    module JobStatus
      class JobStatusAPI < ::API::OpenProjectAPI
        resources :job_statuses do
          route_param :job_id, type: String, desc: 'Job UUID' do
            after_validation do
              @job = ::JobStatus::Status
                .find_by(job_id: params[:job_id], user_id: current_user.id)

              raise API::Errors::NotFound unless @job
            end

            get do
              JobStatusRepresenter.new(@job, current_user: current_user)
            end
          end
        end
      end
    end
  end
end
