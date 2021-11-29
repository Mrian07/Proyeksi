

module RbMasterBacklogsHelper
  include Redmine::I18n

  def render_backlog_menu(backlog)
    # associated javascript defined in taskboard.js
    content_tag(:div, class: 'menu') do
      [
        content_tag(:div, '', class: "menu-trigger icon-context icon-pulldown icon-small"),
        content_tag(:ul, class: 'items') do
          backlog_menu_items_for(backlog).map do |item|
            content_tag(:li, item, class: 'item')
          end.join.html_safe
        end
      ].join.html_safe
    end
  end

  def backlog_menu_items_for(backlog)
    items = common_backlog_menu_items_for(backlog)

    if backlog.sprint_backlog?
      items.merge!(sprint_backlog_menu_items_for(backlog))
    end

    menu = []
    %i[new_story stories_tasks task_board burndown cards wiki configs properties].each do |key|
      menu << items[key] if items.keys.include?(key)
    end

    menu
  end

  def common_backlog_menu_items_for(backlog)
    items = {}

    items[:new_story] = content_tag(:a,
                                    I18n.t('backlogs.add_new_story'),
                                    href: '#',
                                    class: 'add_new_story')

    items[:stories_tasks] = link_to(I18n.t(:label_stories_tasks),
                                    controller: '/rb_queries',
                                    action: 'show',
                                    project_id: @project,
                                    sprint_id: backlog.sprint)

    if @export_card_config_meta[:count] > 0
      items[:configs] = export_export_cards_link(backlog)
    end

    if current_user.allowed_to?(:manage_versions, @project)
      items[:properties] = properties_link(backlog)
    end

    items
  end

  def export_export_cards_link(backlog)
    if @export_card_config_meta[:count] == 1
      link_to(I18n.t(:label_backlogs_export_card_export),
              controller: '/rb_export_card_configurations',
              action: 'show',
              project_id: @project,
              sprint_id: backlog.sprint,
              id: @export_card_config_meta[:default],
              format: :pdf)
    else
      export_modal_link(backlog)
    end
  end

  def properties_link(backlog)
    back_path = backlogs_project_backlogs_path(@project)

    version_path = edit_version_path(backlog.sprint, back_url: back_path, project_id: @project.id)

    link_to(I18n.t(:'backlogs.properties'), version_path)
  end

  def export_modal_link(backlog, options = {})
    path = backlogs_project_sprint_export_card_configurations_path(@project.id, backlog.sprint.id)
    html_id = "modal_work_package_#{SecureRandom.hex(10)}"
    link_to(I18n.t(:label_backlogs_export_card_export), path, options.merge(id: html_id, 'data-modal': ''))
  end

  def sprint_backlog_menu_items_for(backlog)
    items = {}

    items[:task_board] = link_to(I18n.t(:label_task_board),
                                 { controller: '/rb_taskboards',
                                   action: 'show',
                                   project_id: @project,
                                   sprint_id: backlog.sprint },
                                 class: 'show_task_board')

    if backlog.sprint.has_burndown?
      items[:burndown] = content_tag(:a,
                                     I18n.t('backlogs.show_burndown_chart'),
                                     href: '#',
                                     class: 'show_burndown_chart')
    end

    if @project.module_enabled? 'wiki'
      items[:wiki] = link_to(I18n.t(:label_wiki),
                             controller: '/rb_wikis',
                             action: 'edit',
                             project_id: @project,
                             sprint_id: backlog.sprint)
    end

    items
  end
end
