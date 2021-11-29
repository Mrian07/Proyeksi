

module OpenProject::Backlogs::Hooks
  class LayoutHook < OpenProject::Hook::ViewListener
    include RbCommonHelper

    def view_versions_show_bottom(context = {})
      version = context[:version]
      project = version.project

      return '' unless project.module_enabled? 'backlogs'

      snippet = ''

      if User.current.allowed_to?(:edit_wiki_pages, project)
        snippet += '<span id="edit_wiki_page_action">'
        snippet += link_to I18n.t(:button_edit_wiki),
                           { controller: '/rb_wikis', action: 'edit', project_id: project.id, sprint_id: version.id }, class: 'icon icon-edit'
        snippet += '</span>'

        # This wouldn't be necesary if the schedules plugin didn't disable the
        # contextual hook
        snippet += context[:hook_caller].nonced_javascript_tag(<<-JS)
          (function ($) {
            $(document).ready(function() {
              $('#edit_wiki_page_action').detach().appendTo("div.contextual");
            });
          }(jQuery))
        JS
      end
    end

    def view_my_settings(context = {})
      context[:controller].send(
        :render_to_string,
        partial: 'shared/view_my_settings',
        locals: {
          user: context[:user],
          color: context[:user].backlogs_preference(:task_color),
          versions_default_fold_state:
            context[:user].backlogs_preference(:versions_default_fold_state)
        }
      )
    end

    def controller_work_package_new_after_save(context = {})
      params = context[:params]
      work_package = context[:work_package]

      return unless work_package.backlogs_enabled?

      if work_package.is_story?
        if params[:link_to_original]
          rel = Relation.new

          rel.from_id = Integer(params[:link_to_original])
          rel.to_id = work_package.id
          rel.relation_type = Relation::TYPE_RELATES
          rel.save
        end

        if params[:copy_tasks]
          params[:copy_tasks] += ':' if params[:copy_tasks] !~ /:/
          action, id = *params[:copy_tasks].split(/:/)

          story = (id.nil? ? nil : Story.find(Integer(id)))

          if !story.nil? && action != 'none'
            tasks = story.tasks
            case action
            when 'open'
              tasks = tasks.select { |t| !t.closed? }
            when 'all', 'none'
            else
              raise "Unexpected value #{params[:copy_tasks]}"
            end

            tasks.each do |t|
              nt = Task.new
              nt.copy_from(t)
              nt.parent_id = work_package.id
              nt.save
            end
          end
        end
      end
    end
  end
end
