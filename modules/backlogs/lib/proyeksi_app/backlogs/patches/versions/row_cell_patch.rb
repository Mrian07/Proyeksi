

module ProyeksiApp::Backlogs::Patches::Versions::RowCellPatch
  def button_links
    (super + [backlogs_edit_link]).compact
  end

  private

  def backlogs_edit_link
    return if version.project == table.project || !table.project.module_enabled?("backlogs")

    link_to_if_authorized '',
                          { controller: '/versions', action: 'edit', id: version, project_id: table.project.id },
                          class: 'icon icon-edit',
                          title: t(:button_edit)
  end
end
