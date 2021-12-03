module API
  class ProyeksiAppAPI < ::Grape::API
    class << self
      def inherited(api, *)
        super

        # run unscoped patches (i.e. patches that are on the class root, not in a namespace)
        api.apply_patches(nil)
      end
    end
  end
end

Grape::DSL::Routing::ClassMethods.module_eval do
  # Be reload safe. otherwise, an infinite loop occurs on reload.
  unless instance_methods.include?(:orig_namespace)
    alias :orig_namespace :namespace
  end

  def namespace(space = nil, options = {}, &block)
    orig_namespace(space, options) do
      instance_eval(&block)
      apply_patches(space)
    end
  end

  def apply_patches(path)
    (patches[path] || []).each do |patch|
      instance_eval(&patch)
    end
  end

  def patches
    ::Constants::APIPatchRegistry.patches_for(base)
  end
end
