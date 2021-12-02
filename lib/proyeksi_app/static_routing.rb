

module ProyeksiApp
  module StaticRouting
    ##
    # Makes URL helpers accessible outside the view or controller context.
    # It's called static routing url helpers as it does not use request information.
    # For instance it does not read the host from the request but instead
    # it takes the host from the Settings. This may or may not work completely.
    #
    # Most importantly it does work for the '#{model}_path|url' helpers, though.
    module UrlHelpers
      extend ActiveSupport::Concern
      include Rails.application.routes.url_helpers

      included do
        def default_url_options
          options = ActionMailer::Base.default_url_options.clone

          reverse_merge = lambda { |opt, value|
            unless options[opt] || value.blank?
              options[opt] = value
            end
          }

          reverse_merge.call :script_name, ProyeksiApp::Configuration.rails_relative_url_root
          reverse_merge.call :host, ProyeksiApp::StaticRouting::UrlHelpers.host
          reverse_merge.call :protocol,    Setting.protocol

          options
        end
      end

      def self.host
        Setting.host_name&.gsub(/\/.*$/, '') # remove path in case it got into the host
      end
    end

    class StaticRouter
      def url_helpers
        @url_helpers ||= StaticUrlHelpers.new
      end
    end

    class StaticUrlHelpers
      include StaticRouting::UrlHelpers
    end

    ##
    # Try to recognize a route entry for the given path
    # but strips the relative URL root information away beforehand.
    #
    # Returns nil if it could not be processed.
    def self.recognize_route(path)
      return nil unless path.present?

      # Remove relative URL root
      if (relative_url = ProyeksiApp::Configuration.rails_relative_url_root)
        path = path.gsub relative_url, ''
      end

      Rails.application.routes.recognize_path(path)
    rescue ActionController::RoutingError
      nil
    end
  end
end
