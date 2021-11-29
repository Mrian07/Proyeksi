#-- encoding: UTF-8



module API
  module V3
    module Projects
      module Copy
        class ProjectCopyPayloadRepresenter < ::API::V3::Projects::ProjectRepresenter
          include ::API::Utilities::PayloadRepresenter
          include ::API::Utilities::MetaProperty

          cached_representer disabled: true

          def meta_representer_class
            ProjectCopyMetaRepresenter
          end
        end
      end
    end
  end
end
