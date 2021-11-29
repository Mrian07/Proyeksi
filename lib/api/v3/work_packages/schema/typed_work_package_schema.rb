#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      module Schema
        class TypedWorkPackageSchema < BaseWorkPackageSchema
          attr_reader :project, :type, :custom_fields

          def initialize(project:, type:, custom_fields: nil)
            @project = project
            @type = type
            @custom_fields = custom_fields
          end

          def milestone?
            type.is_milestone?
          end

          def available_custom_fields
            custom_fields || (project.all_work_package_custom_fields.to_a & type.custom_fields.to_a)
          end

          def no_caching?
            false
          end

          private

          def contract
            @contract ||= begin
              ::API::V3::WorkPackages::Schema::TypedSchemaContract
                .new(work_package,
                     User.current)
            end
          end

          def work_package
            @work_package ||= WorkPackage
                              .new(project: project,
                                   type: type)
          end
        end
      end
    end
  end
end
