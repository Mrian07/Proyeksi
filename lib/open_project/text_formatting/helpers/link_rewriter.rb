#-- encoding: UTF-8



module OpenProject::TextFormatting
  module Helpers
    ##
    # Rewrite relative URLs to their absolute paths
    # when only_path is false.
    class LinkRewriter
      attr_reader :context

      def initialize(context)
        @context = context
      end

      ##
      # Test whether the given URL is relative and we need to replace it
      def applicable?(url)
        context[:only_path] == false && url.start_with?('/')
      end

      ##
      # Replace the given relative_url to an absolute URL
      # from the current context
      def replace(relative_url)
        protocol, host_with_port = determine_url_segments
        return relative_url unless protocol && host_with_port

        "#{protocol}#{host_with_port}#{relative_url}"
      end

      def determine_url_segments
        if request = context[:request]
          return [request.protocol, request.host_with_port]
        end

        url_opts = url_helpers.default_url_options
        ["#{url_opts[:protocol]}://", url_opts[:host]]
      end

      def url_helpers
        @url_helpers ||= OpenProject::StaticRouting::StaticUrlHelpers.new
      end
    end
  end
end
