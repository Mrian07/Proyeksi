

require 'open_project/plugins'

module OpenProject::PDFExport
  class Engine < ::Rails::Engine
    engine_name :openproject_pdf_export

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-pdf_export',
             author_url: 'https://www.openproject.org',
             bundled: true do
      menu :admin_menu,
           :export_card_configurations,
           { controller: '/export_card_configurations', action: 'index' },
           caption: :label_export_card_configuration_plural,
           parent: :admin_backlogs
    end
  end
end
