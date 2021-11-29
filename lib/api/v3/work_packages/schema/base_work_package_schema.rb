#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      module Schema
        class BaseWorkPackageSchema
          def project
            nil
          end

          def type
            nil
          end

          def assignable_values(_property, _current_user)
            nil
          end

          def assignable_custom_field_values(_custom_field)
            nil
          end

          def available_custom_fields
            []
          end

          def writable?(property)
            property = property.to_sym

            # Special case for milestones + date property
            property = :start_date if property == :date && milestone?

            @writable_attributes ||= begin
              contract.writable_attributes
            end

            property_name = ::API::Utilities::PropertyNameConverter.to_ar_name(property, context: work_package)

            @writable_attributes.include?(property_name)
          end

          def milestone?
            false
          end

          def readonly?
            work_package.readonly_status?
          end

          private

          def contract
            raise NotImplementedError
          end
        end
      end
    end
  end
end
