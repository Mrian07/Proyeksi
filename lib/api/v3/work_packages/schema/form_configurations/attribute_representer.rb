

module API
  module V3
    module WorkPackages
      module Schema
        module FormConfigurations
          class AttributeRepresenter < ::API::Decorators::Single
            attr_accessor :project

            def initialize(model, current_user:, project:, embed_links: false)
              self.project = project

              super(model, current_user: current_user, embed_links: embed_links)
            end

            property :name,
                     exec_context: :decorator

            property :attributes,
                     exec_context: :decorator

            def _type
              "WorkPackageFormAttributeGroup"
            end

            def name
              represented.translated_key
            end

            def attributes
              represented.active_members(project).map do |attribute|
                convert_property(attribute)
              end
            end

            def convert_property(attribute)
              ::API::Utilities::PropertyNameConverter.from_ar_name(attribute)
            end
          end
        end
      end
    end
  end
end
