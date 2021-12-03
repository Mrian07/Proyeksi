#-- encoding: UTF-8

module API
  module Decorators
    module DateProperty
      def self.included(base)
        base.extend ClassMethods
      end

      def self.prepended(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def date_property(name,
                          getter: default_date_getter(name),
                          setter: default_date_setter(name),
                          **args)

          attributes = {
            getter: getter,
            setter: setter,
            render_nil: true
          }

          property name,
                   attributes.merge(args)
        end

        def date_time_property(name,
                               getter: default_date_time_getter(name),
                               **args)

          attributes = {
            getter: getter,
            render_nil: true
          }

          property name,
                   attributes.merge(args)
        end

        private

        def default_date_getter(name)
          ->(represented:, decorator:, **) {
            decorator.datetime_formatter.format_date(represented.send(name), allow_nil: true)
          }
        end

        def default_date_setter(name)
          ->(fragment:, decorator:, **) {
            date = decorator
                     .datetime_formatter
                     .parse_date(fragment,
                                 name.to_s.camelize(:lower),
                                 allow_nil: true)

            send(:"#{name}=", date)
          }
        end

        def default_date_time_getter(name)
          ->(represented:, decorator:, **) {
            decorator.datetime_formatter.format_datetime(represented.send(name), allow_nil: true)
          }
        end
      end
    end
  end
end
