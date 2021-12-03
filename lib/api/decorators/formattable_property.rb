#-- encoding: UTF-8

module API
  module Decorators
    module FormattableProperty
      def self.included(base)
        base.extend ClassMethods
      end

      def self.prepended(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def formattable_property(name,
                                 plain: false,
                                 getter: default_formattable_getter(name, plain),
                                 setter: default_formattable_setter(name),
                                 **args)

          attributes = {
            exec_context: :decorator,
            getter: getter,
            setter: setter,
            render_nil: true
          }

          property name,
                   attributes.merge(**args)
        end

        private

        def default_formattable_getter(name, plain = false)
          ->(*) {
            ::API::Decorators::Formattable.new(represented.send(name),
                                               object: represented,
                                               plain: plain)
          }
        end

        def default_formattable_setter(name)
          ->(fragment:, **) {
            represented.send(:"#{name}=", fragment['raw'])
          }
        end
      end
    end
  end
end
