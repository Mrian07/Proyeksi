module Settings
  ##
  # A language switch and text area for updating a localized text setting.
  class TextSettingCell < ::RailsCell
    include ActionView::Helpers::JavaScriptHelper
    include ActionView::Helpers::FormOptionsHelper
    include ProyeksiApp::FormTagHelper
    include TextFormattingHelper

    options :name # name of setting and tag to differentiate between different language selects

    def current_language
      model
    end
  end
end
