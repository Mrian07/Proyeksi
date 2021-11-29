#-- encoding: UTF-8



module API
  module Utilities
    class ResourceLinkParser
      # N.B. valid characters for URL path segments as of
      # http://tools.ietf.org/html/rfc3986#section-3.3
      SEGMENT_CHARACTER = '(\w|[-~!$&\'\(\)*+\.,:;=@]|%[0-9A-Fa-f]{2})'.freeze
      RESOURCE_REGEX =
        "/api/v(?<version>\\d)/(?<namespace>[\\w\/]+)/(?<id>#{SEGMENT_CHARACTER}+)\\z".freeze

      class << self
        def parse(resource_link)
          parse_resource(resource_link)
        end

        def parse_id(resource_link,
                     property:,
                     expected_version: nil,
                     expected_namespace: nil)
          raise ArgumentError unless resource_link

          resource = parse(resource_link)

          if resource
            version_valid = matches_expectation?(expected_version, resource[:version])
            namespace_valid = matches_expectation?(expected_namespace, resource[:namespace])
          end

          unless resource && version_valid && namespace_valid
            expected_link = make_expected_link(expected_version, expected_namespace)
            fail ::API::Errors::InvalidResourceLink.new(property, expected_link, resource_link)
          end

          resource[:id]
        end

        private

        def parse_resource(resource_link)
          match = resource_matcher.match(resource_link)

          return nil unless match

          {
            version: match[:version],
            namespace: match[:namespace],
            id: unescape(match[:id])
          }
        end

        def resource_matcher
          @resource_matcher ||= Regexp.compile(RESOURCE_REGEX)
        end

        def unescape(string)
          @unescaper ||= Addressable::Template.new('{+id}')

          @unescaper.extract(string)['id']
        end

        # returns whether expectation and actual are identical
        # will always be true if there is no expectation (nil)
        def matches_expectation?(expected, actual)
          expected.nil? || Array(expected).any? { |e| e.to_s == actual }
        end

        def make_expected_link(version, namespaces)
          version = "v#{version}" || ':apiVersion'
          namespaces = Array(namespaces || ':resource')

          namespaces.map { |namespace| "/api/#{version}/#{namespace}/:id" }
        end
      end
    end
  end
end
