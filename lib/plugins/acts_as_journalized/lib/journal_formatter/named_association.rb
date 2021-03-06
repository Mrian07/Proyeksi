

module JournalFormatter
  class NamedAssociation < Attribute
    def render(key, values, options = { no_html: false })
      label, old_value, value = format_details(key, values, options)

      unless options[:no_html]
        label, old_value, value = *format_html_details(label, old_value, value)
      end

      render_ternary_detail_text(label, value, old_value, options)
    end

    private

    def format_details(key, values, options = {})
      label = label(key)

      old_value, value = *format_values(values, key, options)

      [label, old_value, value]
    end

    def format_values(values, key, options)
      field = key.to_s.gsub(/_id\z/, '').to_sym
      klass = class_from_field(field)

      values.map do |value|
        if klass
          record = associated_object(klass, value.to_i, options)
          if record
            if record.respond_to? 'name'
              record.name
            else
              record.subject
            end
          end
        end
      end
    end

    def associated_object(klass, id, options = {})
      cache = options[:cache]

      if cache.is_a?(Acts::Journalized::JournalObjectCache)
        cache.fetch(klass, id) do |k, i|
          k.find_by(id: i)
        end
      else
        klass.find_by(id: id)
      end
    end

    def label(key)
      @journal.journable.class.human_attribute_name(key.to_s.gsub(/_id$/, ''))
    end

    def class_from_field(field)
      association = @journal.journable.class.reflect_on_association(field)

      association&.class_name&.constantize
    end
  end
end
