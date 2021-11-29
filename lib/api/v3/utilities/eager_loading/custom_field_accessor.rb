#-- encoding: UTF-8



module API
  module V3
    module Utilities
      module EagerLoading
        module CustomFieldAccessor
          extend ActiveSupport::Concern

          included do
            # Because of the ruby method lookup,
            # wrapping the work_package here and define the
            # available_custom_fields methods on the wrapper does not suffice.
            # We thus extend each work package.
            def initialize(object)
              super
              object.extend(CustomFieldAccessorPatch)
            end

            module CustomFieldAccessorPatch
              def available_custom_fields
                @available_custom_fields
              end

              def available_custom_fields=(fields)
                @available_custom_fields = fields
              end
            end
          end
        end
      end
    end
  end
end
