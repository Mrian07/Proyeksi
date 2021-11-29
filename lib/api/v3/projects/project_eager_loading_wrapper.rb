#-- encoding: UTF-8



module API
  module V3
    module Projects
      class ProjectEagerLoadingWrapper < API::V3::Utilities::EagerLoading::EagerLoadingWrapper
        include API::V3::Utilities::EagerLoading::CustomFieldAccessor

        class << self
          def wrap(projects)
            custom_fields = if projects.present?
                              projects.first.available_custom_fields
                            end

            super
              .each { |project| project.available_custom_fields = custom_fields }
          end
        end
      end
    end
  end
end
