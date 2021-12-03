

module ProyeksiApp::Bim::Hooks
  class Hook < ProyeksiApp::Hook::Listener
    include ActionView::Helpers::TagHelper
    include ActionView::Context
    include WorkPackagesHelper

    def admin_information_checklist(*)
      [
        [:'extraction.available.ifc_convert', ::Bim::IfcModels::ViewConverterService.available?]
      ]
    end
  end
end
