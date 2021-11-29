

module Acts::Journalized
  module FormatHooks
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Shortcut to register a formatter for a number of fields
      def register_on_journal_formatter(formatter, *field_names)
        formatter = formatter.to_sym
        journal_class = self.journal_class
        field_names.each do |field|
          JournalFormatter.register_formatted_field(journal_class.name.to_sym, field, formatter)
        end
      end

      # Shortcut to register a new proc as a named formatter. Overwrites
      # existing formatters with the same name
      def register_journal_formatter(formatter, klass = nil, &block)
        if block_given?
          klass = Class.new(JournalFormatter::Proc) do
            @proc = block
          end
        end

        raise ArgumentError 'Provide either a class or a block defining the value formatting' if klass.nil?

        JournalFormatter.register formatter.to_sym => klass
      end
    end
  end
end
