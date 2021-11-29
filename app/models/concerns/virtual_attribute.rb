

module VirtualAttribute
  extend ActiveSupport::Concern

  class_methods do
    def virtual_attribute(attribute, cast_type: :string, &block)
      attribute attribute, cast_type
      define_attribute_method attribute

      include InstanceMethods

      _define_virtual_attribute_setter(attribute)
      _define_virtual_attribute_getter(attribute, &block)
      _define_virtual_attribute_reload(attribute)
      _define_virtual_attributes_hook(attribute)
    end

    private

    def _define_virtual_attributes_hook(attribute)
      define_method :attributes do |*args|
        # Ensure attribute has been read
        send(attribute)
        super(*args)
      end

      # Ensure the virtual attribute is unset before destroying
      before_destroy { send(:"#{attribute}=", nil) }
    end

    def _define_virtual_attribute_setter(attribute)
      define_method "#{attribute}=" do |value|
        set_virtual_attribute(attribute, value) if send(attribute) != value
        instance_variable_set(:"@#{attribute}_set", true)
        instance_variable_set(:"@#{attribute}", value)
      end
    end

    def _define_virtual_attribute_getter(attribute, &block)
      define_method attribute do
        if instance_variable_get(:"@#{attribute}_set")
          instance_variable_get(:"@#{attribute}")
        else
          value = instance_eval(&block)

          set_virtual_attribute_was(attribute, value)

          instance_variable_set(:"@#{attribute}", value)
        end
      end
    end

    def _define_virtual_attribute_reload(attribute)
      define_method :reload do |*args|
        instance_variable_set(:"@#{attribute}", nil)
        instance_variable_set(:"@#{attribute}_set", nil)

        super(*args)
      end
    end
  end

  module InstanceMethods
    # Used to persists the changes to the virtual attribute in the mutation_tracker used by
    # AR::Dirty so that it looks like every other attribute.
    # Using attribute_will_change! does not place the value in the tracker but merely forces
    # the attribute to be returned when asking the object for changes.
    def set_virtual_attribute_was(attribute, value)
      attributes = mutations_from_database.send(:attributes)
      attributes[attribute.to_s].instance_variable_set(:@value_before_type_cast, value)
    end

    def set_virtual_attribute(attribute, value)
      attributes = mutations_from_database.send(:attributes)
      attributes[attribute.to_s] = attributes[attribute.to_s].with_value_from_user(value)
    end
  end
end
