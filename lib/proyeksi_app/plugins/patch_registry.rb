

module ProyeksiApp::Plugins
  module PatchRegistry
    def self.register(target, patch)
      ActiveSupport.on_load(target) do
        require_dependency patch
        constant = patch.camelcase.constantize

        target.to_s.camelcase.constantize.send(:include, constant)
      end
    end

    def self.patches
      @patches ||= Hash.new do |h, k|
        h[k] = []
      end
    end
  end
end
