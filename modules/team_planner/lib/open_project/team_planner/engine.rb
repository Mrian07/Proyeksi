

module OpenProject::TeamPlanner
  class Engine < ::Rails::Engine
    engine_name :openproject_team_planner

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-team_planner',
             author_url: 'https://www.openproject.org',
             bundled: true,
             settings: {},
             name: 'OpenProject Team Planner' do
      project_module :team_planner_view, dependencies: :work_package_tracking do
        permission :view_team_planner,
                   { 'team_planner/team_planner': %i[index] },
                   dependencies: %i[view_work_packages]
        permission :manage_team_planner,
                   { 'team_planner/team_planner': %i[index] },
                   dependencies: %i[view_team_planner add_work_packages edit_work_packages manage_public_queries]
      end

      menu :project_menu,
           :team_planner_view,
           { controller: '/team_planner/team_planner', action: :index },
           caption: :'team_planner.label_team_planner',
           after: :backlogs,
           icon: 'icon2 icon-calendar',
           badge: 'label_menu_badge.pre_alpha'
    end
  end
end
