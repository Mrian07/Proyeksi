

# The sole purpose of this is to have a work package
# that is inexpensive to initialize by overriding the after_initialize hook

module API
  module Utilities
    class PropertyNameConverterWorkPackageDummy < ::WorkPackage
      def set_default_values; end
    end
  end
end
