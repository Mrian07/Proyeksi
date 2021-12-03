

require 'proyeksi_app/plugins'

module ProyeksiApp::PDFExport
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_pdf_export

    include ProyeksiApp::Plugins::ActsAsOpEngine

    register 'proyeksiapp-pdf_export',
             author_url: 'https://www.proyeksiapp.org',
             bundled: true do
      menu :admin_menu,
           :export_card_configurations,
           { controller: '/export_card_configurations', action: 'index' },
           caption: :label_export_card_configuration_plural,
           parent: :admin_backlogs
    end
  end
end
