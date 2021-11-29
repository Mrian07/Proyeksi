#-- encoding: UTF-8



require 'api/v3/priorities/priority_collection_representer'
require 'api/v3/priorities/priority_representer'

module API
  module V3
    module Priorities
      class PrioritiesAPI < ::API::OpenProjectAPI
        resources :priorities do
          after_validation do
            authorize(:view_work_packages, global: true)

            @priorities = IssuePriority.all
          end

          get do
            PriorityCollectionRepresenter.new(@priorities,
                                              self_link: api_v3_paths.priorities,
                                              current_user: current_user)
          end

          route_param :id, type: Integer, desc: 'Priority ID' do
            after_validation do
              @priority = IssuePriority.find(params[:id])
            end

            get do
              PriorityRepresenter.new(@priority, current_user: current_user)
            end
          end
        end
      end
    end
  end
end
