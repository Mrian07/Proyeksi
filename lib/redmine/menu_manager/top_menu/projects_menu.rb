

module Redmine::MenuManager::TopMenu::ProjectsMenu
  def render_projects_top_menu_node
    return '' if User.current.anonymous? and Setting.login_required?
    return '' if User.current.anonymous? and User.current.number_of_known_projects.zero?

    render_projects_dropdown
  end

  private

  def render_projects_dropdown
    label = !!(@project && !@project.name.empty?) ? @project.name : t(:label_select_project)
    render_menu_dropdown_with_items(
      label: label,
      label_options: {
        id: 'projects-menu',
        accesskey: ProyeksiApp::AccessKeys.key_for(:project_search),
        span_class: 'ellipsis'
      },
      items: project_items,
      options: {
        drop_down_class: 'drop-down--projects'
      }
    ) do
      content_tag(:li, id: 'project-search-container') do
        angular_component_tag('project-menu-autocomplete')
      end
    end
  end

  def project_items
    [project_index_item]
  end

  def project_index_item
    Redmine::MenuManager::MenuItem.new(
      :list_projects,
      main_app.projects_path,
      caption: t(:label_project_view_all),
      icon: "icon-show-all-projects icon4"
    )
  end

  include ProyeksiApp::StaticRouting::UrlHelpers
end
