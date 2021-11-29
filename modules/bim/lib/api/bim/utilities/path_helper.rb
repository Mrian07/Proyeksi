#-- encoding: UTF-8



module API
  module Bim
    module Utilities
      module PathHelper
        include API::Utilities::UrlHelper

        # rubocop:disable Naming/ClassAndModuleCamelCase
        class BCF2_1Path
          # rubocop:enable Naming/ClassAndModuleCamelCase
          extend API::Utilities::UrlHelper

          # Determining the root_path on every url we want to render is
          # expensive. As the root_path will not change within a
          # request, we can cache the first response on each request.
          def self.root_path
            RequestStore.store[:cached_root_path] ||= super
          end

          def self.root
            "#{root_path}api/bcf/2.1/"
          end

          def self.project(identifier)
            "#{root}projects/#{identifier}"
          end

          def self.topics(project_identifier)
            "#{project(project_identifier)}/topics"
          end

          def self.topic(project_identifier, uuid)
            "#{topics(project_identifier)}/#{uuid}"
          end

          def self.viewpoint(project_identifier, topic_uuid, viewpoint_topic)
            "#{topic(project_identifier, topic_uuid)}/viewpoints/#{viewpoint_topic}"
          end
        end

        def bcf_v2_1_paths
          BCF2_1Path
        end
      end
    end
  end
end
