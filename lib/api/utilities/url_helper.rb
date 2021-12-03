#-- encoding: UTF-8

module API
  module Utilities
    module UrlHelper
      include ActionView::Helpers::UrlHelper
      include ProyeksiApp::StaticRouting::UrlHelpers

      # The URL helpers need a controller, even if it's nil
      def controller; end
    end
  end
end
