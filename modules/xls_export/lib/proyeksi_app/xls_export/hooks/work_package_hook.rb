module ProyeksiApp::XlsExport::Hooks
  class WorkPackageHook < ProyeksiApp::Hook::ViewListener
    def link_to_xls(context, label, options = {})
      url = {
        project_id: context[:project],
        format: "xls"
      }

      context[:link_formatter].link_to label, url: url.merge(options)
    end
  end
end
