module ProyeksiApp::XlsExport::Hooks
  class CostReportHook < ProyeksiApp::Hook::ViewListener
    render_on :view_cost_report_toolbar, partial: 'hooks/xls_report/view_cost_report_toolbar'
  end
end
