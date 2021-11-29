

module OpenProject::Boards
  class Engine < ::Rails::Engine
    engine_name :openproject_boards

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-boards',
             author_url: 'https://www.openproject.org',
             bundled: true,
             settings: {},
             name: 'OpenProject Boards' do
      project_module :board_view, dependencies: :work_package_tracking, order: 80 do
        permission :show_board_views, 'boards/boards': %i[index], dependencies: :view_work_packages
        permission :manage_board_views, 'boards/boards': %i[index], dependencies: :manage_public_queries
      end

      menu :project_menu,
           :board_view,
           { controller: '/boards/boards', action: :index },
           caption: :'boards.label_boards',
           after: :work_packages,
           icon: 'icon2 icon-boards'

      menu :project_menu,
           :board_menu,
           { controller: '/boards/boards', action: :index },
           parent: :board_view,
           partial: 'boards/boards/menu_board',
           last: true,
           caption: :'boards.label_boards'
    end

    patch_with_namespace :BasicData, :SettingSeeder

    config.to_prepare do
      OpenProject::Boards::GridRegistration.register!
    end
  end
end
