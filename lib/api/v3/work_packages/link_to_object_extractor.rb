#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      module LinkToObjectExtractor
        def self.parse_links(links)
          links.keys.each_with_object({}) do |attribute, h|
            resource = ::API::Utilities::ResourceLinkParser.parse links[attribute]['href']

            if resource
              case resource[:namespace]
              when 'statuses'
                h[:status_id] = resource[:id]
              end
            end
          end
        end
      end
    end
  end
end
