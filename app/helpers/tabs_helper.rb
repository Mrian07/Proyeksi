#-- encoding: UTF-8



module TabsHelper
  # Renders tabs and their content
  def render_tabs(tabs, form = nil)
    if tabs.any?
      selected = selected_tab(tabs)
      render partial: 'common/tabs', locals: { f: form, tabs: tabs, selected_tab: selected }
    else
      content_tag 'p', I18n.t(:label_no_data), class: 'nodata'
    end
  end

  def selected_tab(tabs)
    tabs.detect { |t| t[:name] == params[:tab] } || tabs.first
  end

  # Render tabs from the ui/extensible tabs manager
  def render_extensible_tabs(key, params = {})
    tabs = ::OpenProject::Ui::ExtensibleTabs.enabled_tabs(key).map do |tab|
      path = tab[:path].respond_to?(:call) ? instance_exec(params, &tab[:path]) : tab[:path]
      tab.dup.merge path: path
    end
    render_tabs(tabs)
  end
end
