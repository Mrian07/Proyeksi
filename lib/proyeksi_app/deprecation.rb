

module ProyeksiApp::Deprecation
  class << self
    def deprecator
      @@deprecator ||= ActiveSupport::Deprecation
          .new('in a future major upgrade', 'ProyeksiApp')
          .tap do |instance|
        # Reuse the silenced state of the default deprecator
        instance.silenced = ActiveSupport::Deprecation.silenced
      end
    end

    delegate :warn, to: :deprecator

    ##
    # Deprecate the given method with a notice regarding future removal
    #
    # @mod [Class] The module on which the method is to be replaced.
    # @method [:symbol] The method to replace.
    # @replacement [nil, :symbol, String] The replacement method.
    def deprecate_method(mod, method, replacement = nil)
      deprecator.deprecate_methods(mod, method => replacement)
    end

    ##
    # Deprecate the given class method with a notice regarding future removal
    #
    # @mod [Class] The module on which the method is to be replaced.
    # @method [:symbol] The method to replace.
    # @replacement [nil, :symbol, String] The replacement method.
    def deprecate_class_method(mod, method, replacement = nil)
      deprecate_method(mod.singleton_class, method, replacement)
    end

    def replaced(old_method, new_method, called_from)
      message = <<~MSG
        #{old_method} is deprecated and will be removed in a future ProyeksiApp version.

        Please use #{new_method} instead.

      MSG

      ActiveSupport::Deprecation.warn message, called_from
    end
  end
end
