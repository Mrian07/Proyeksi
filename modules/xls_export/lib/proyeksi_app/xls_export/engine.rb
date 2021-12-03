module ProyeksiApp::XlsExport
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_xls_export

    include ProyeksiApp::Plugins::ActsAsOpEngine

    register 'proyeksiapp-xls_export',
             author_url: 'https://www.proyeksiapp.org',
             bundled: true

    patches %i[CostReportsController]

    initializer 'xls_export.register_hooks' do
      # don't use require_dependency to not reload hooks in development mode

      require 'proyeksi_app/xls_export/hooks/cost_report_hook'

      require 'proyeksi_app/xls_export/hooks/work_package_hook'
    end

    initializer 'xls_export.register_mimetypes' do
      next if defined? Mime::XLS

      Mime::Type.register('application/vnd.ms-excel',
                          :xls,
                          %w(application/vnd.ms-excel))
    end

    class_inflection_override('xls' => 'XLS')

    config.to_prepare do
      ::Exports::Register.register do
        list(::WorkPackage, XlsExport::WorkPackage::Exporter::XLS)
        list(::Project, XlsExport::Project::Exporter::XLS)
      end
    end
  end
end
