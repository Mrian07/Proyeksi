module API
  module PatchableAPI
    def self.included(base)
      base.class_eval do
        prepend ClassMethods
      end
    end

    module ClassMethods
      def inherited(api, base_instance_parent = Grape::API::Instance)
        super

        # run unscoped patches (i.e. patches that are on the class root, not in a namespace)
        api.send(:execute_patches_for, nil)
      end

      def namespace(name, *args, &block)
        super(name, *args) do
          instance_eval(&block)
          execute_patches_for(name)
        end
      end

      # we need to repeat all the aliases for them to work properly...
      alias_method :group, :namespace
      alias_method :resource, :namespace
      alias_method :resources, :namespace
      alias_method :segment, :namespace

      private

      def execute_patches_for(path)
        if patches[path]
          patches[path].each do |patch|
            instance_eval(&patch)
          end
        end
      end

      def patches
        ::Constants::APIPatchRegistry.patches_for(self)
      end
    end
  end
end
