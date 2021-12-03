#-- encoding: UTF-8

module API
  module Utilities
    # When ROAR is tasked with creating embedded representers, it accepts a Decorator class
    # that it will try to instantiate itself. However, we need to transfer contextual information
    # like the current_user into our representers. We will therefore not pass the actual decorator
    # class, but a factory that behaves like one, except for passing hidden information.
    class DecoratorFactory
      def initialize(decorator:, current_user:)
        @decorator = decorator
        @current_user = current_user
      end

      def new(represented)
        @decorator.create(represented, current_user: @current_user)
      end

      # Roar will actually call the prepare method, which delegates to new.
      # N.B. This carries the assumption that the prepare method will never do more than delegate.
      alias_method :prepare, :new
    end
  end
end
