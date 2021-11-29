#-- encoding: UTF-8



module OpenProject
  class CustomFieldFormat
    include Redmine::I18n

    cattr_accessor :available
    @@available = {}

    attr_accessor :name, :order, :label, :edit_as, :class_names, :formatter

    def initialize(name, label:, order:, edit_as: name, only: nil, formatter: 'CustomValue::StringStrategy')
      self.name = name
      self.label = label
      self.order = order
      self.edit_as = edit_as
      self.class_names = only
      self.formatter = formatter
    end

    def formatter
      # avoid using stale definitions in dev mode
      Kernel.const_get(@formatter)
    end

    class << self
      def map(&_block)
        yield self
      end

      # Registers a custom field format
      def register(custom_field_format, _options = {})
        @@available[custom_field_format.name] = custom_field_format unless @@available.keys.include?(custom_field_format.name)
      end

      def available_formats
        @@available.keys
      end

      def find_by_name(name)
        @@available[name.to_s]
      end

      def all_for_field(custom_field)
        class_name = custom_field.class.customized_class.name

        available
          .values
          .select { |field| field.class_names.nil? || field.class_names.include?(class_name) }
      end
    end
  end
end
