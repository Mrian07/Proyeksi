

require 'representable'
require 'open_project/patches'

module OpenProject::Patches::Representable
  module DecoratorPatch
    def self.included(base)
      base.class_eval do
        def self.as_strategy=(strategy)
          raise 'The :as_strategy option should respond to #call?' unless strategy.respond_to?(:call)

          @as_strategy = strategy
        end

        def self.as_strategy
          @as_strategy
        end

        def self.property(name, options = {}, &block)
          options = { as: as_strategy.call(name.to_s) }.merge(options) if as_strategy

          super
        end
      end
    end
  end

  module OverwriteOnNilPatch
    def self.included(base)
      base.class_eval do
        unless const_defined?(:OverwriteOnNil)
          raise "Missing OverwriteOnNil on Representable gem, check if this patch still applies"
        end

        remove_const :OverwriteOnNil

        ##
        # Redefine OverwriteOnNil to ensure we use the correct setter
        # https://github.com/trailblazer/representable/issues/234
        const_set(:OverwriteOnNil, ->(input, *) { input })
      end
    end
  end
end

OpenProject::Patches.patch_gem_version 'representable', '3.1.1' do
  unless Representable::Decorator.included_modules.include?(OpenProject::Patches::Representable::DecoratorPatch)
    Representable::Decorator.include OpenProject::Patches::Representable::DecoratorPatch
  end

  unless Representable::Decorator.included_modules.include?(OpenProject::Patches::Representable::OverwriteOnNilPatch)
    Representable.include OpenProject::Patches::Representable::OverwriteOnNilPatch
  end
end
