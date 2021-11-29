#-- encoding: UTF-8



require 'api/v3/statuses/status_collection_representer'
require 'api/v3/statuses/status_representer'

module API
  module V3
    module Statuses
      class StatusesAPI < ::API::OpenProjectAPI
        resources :statuses do
          after_validation do
            authorize(:view_work_packages, global: true)
          end

          get do
            StatusCollectionRepresenter.new(Status.all,
                                            self_link: api_v3_paths.statuses,
                                            current_user: current_user)
          end

          route_param :id, type: Integer, desc: 'Status ID' do
            helpers do
              # Note that naming the method #status or having
              # a variable named @status colides with grape.
              def work_package_status
                Status.find(params[:id])
              end
            end

            get do
              StatusRepresenter.new(work_package_status, current_user: current_user)
            end
          end
        end
      end
    end
  end
end
