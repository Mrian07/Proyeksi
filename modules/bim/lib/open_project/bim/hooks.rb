

module OpenProject::Bim::Hooks
  class Hook < OpenProject::Hook::Listener
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
