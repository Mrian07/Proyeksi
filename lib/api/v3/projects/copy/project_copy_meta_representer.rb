#-- encoding: UTF-8

module API
  module V3
    module Projects
      module Copy
        class ProjectCopyMetaRepresenter < ::API::Decorators::Single
          ::Projects::CopyService.copyable_dependencies.each do |dep|
            identifier = dep[:identifier]

            property :"copy_#{identifier}",
                     exec_context: :decorator,
                     getter: ->(*) do
                       only = represented&.only

                       only.nil? || only.include?(identifier)
                     end,
                     reader: ->(doc:, **) { doc.fetch("copy#{identifier.camelize}", true) },
                     setter: ->(fragment:, **) do
                       represented.only ||= Set.new
                       represented.only << identifier unless fragment == false
                     end
          end

          property :send_notifications,
                   exec_context: :decorator,
                   getter: ->(*) do
                     # Default to true
                     represented.send_notifications != false
                   end,
                   setter: ->(fragment:, **) do
                     represented.send_notifications = fragment
                   end

          def model_required?
            false
          end
        end
      end
    end
  end
end
