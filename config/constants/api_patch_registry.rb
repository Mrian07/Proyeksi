

module Constants
  class APIPatchRegistry
    class << self
      def add_patch(class_name, path, &block)
        patch_maps_by_class[class_name] = {} unless patch_maps_by_class[class_name]
        patch_map = patch_maps_by_class[class_name]

        path = ":#{path}" if path.is_a?(Symbol)

        if Object.const_defined?(class_name)
          raise "Adding patch #{block} to #{class_name} after it is already loaded has no effect."
        end

        patch_map[path] = [] unless patch_map[path]
        patch_map[path] << block
      end

      def patches_for(klass)
        patch_maps_by_class[klass.to_s] || {}
      end

      private

      def patch_maps_by_class
        @patch_maps_by_class ||= {}
      end
    end
  end
end
