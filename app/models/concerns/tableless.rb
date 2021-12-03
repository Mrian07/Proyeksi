module Tableless
  extend ActiveSupport::Concern

  def persisted?
    false
  end

  class_methods do
    def attribute_names
      @attribute_names ||= attribute_types.keys
    end

    def load_schema!
      @columns_hash ||= Hash.new

      # From active_record/attributes.rb
      attributes_to_define_after_schema_loads.each do |name, (type, options)|
        if type.is_a?(Symbol)
          type = ActiveRecord::Type.lookup(type, **options.except(:default))
        end

        define_attribute(name, type, **options.slice(:default))

        # Improve Model#inspect output
        @columns_hash[name.to_s] = ActiveRecord::ConnectionAdapters::Column.new(name.to_s, options[:default])
      end
    end
  end
end
