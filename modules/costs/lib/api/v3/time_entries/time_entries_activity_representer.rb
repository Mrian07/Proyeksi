#-- encoding: UTF-8



module API
  module V3
    module TimeEntries
      class TimeEntriesActivityRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource

        self_link

        property :id

        property :name

        property :position

        property :is_default,
                 as: :default

        associated_resources :projects,
                             link: ->(*) {
                               active_projects.map do |project|
                                 {
                                   href: api_v3_paths.project(project.identifier),
                                   title: project.name
                                 }
                               end
                             },
                             getter: ->(*) {
                               active_projects.map do |project|
                                 Projects::ProjectRepresenter.new(project, current_user: current_user)
                               end
                             }

        def _type
          'TimeEntriesActivity'
        end

        def active_projects
          Project.visible_with_activated_time_activity(represented)
        end
      end
    end
  end
end
