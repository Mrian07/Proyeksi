#-- encoding: UTF-8



module OpenProject::TextFormatting::Matchers
  module LinkHandlers
    class Base
      include ::OpenProject::TextFormatting::Truncation
      # used for the work package quick links
      include WorkPackagesHelper
      # Used for escaping helper 'h()'
      include ERB::Util
      # Rails helper
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::TextHelper
      # For route path helpers
      include OpenProject::ObjectLinking
      include OpenProject::StaticRouting::UrlHelpers

      attr_reader :matcher, :context

      def initialize(matcher, context:)
        @matcher = matcher
        @context = context
      end

      ##
      # Allowed prefixes for this matcher
      def self.allowed_prefixes
        []
      end

      def allowed_prefixes
        self.class.allowed_prefixes
      end

      ##
      # Test whether we should try to resolve the given link
      def applicable?
        raise NotImplementedError
      end

      ##
      # Replace the given link with the resource link, depending on the context
      # and matchers.
      # If nil is returned, the link remains as-is.
      def call
        raise NotImplementedError
      end

      def oid
        unless identifier.nil?
          identifier.to_i
        end
      end

      def identifier
        matcher.identifier
      end

      def project
        matcher.project
      end

      ##
      # Call a named route with _path when only_path is true
      # or _url when not.
      #
      # Passes on all remaining params.
      def named_route(name, **args)
        route = if context[:only_path]
                  :"#{name}_path"
                else
                  :"#{name}_url"
                end

        public_send(route, **args)
      end

      def controller; end
    end
  end
end
