#-- encoding: UTF-8



module ProyeksiApp
  module Activity
    class << self
      def available_event_types
        @available_event_types ||= []
      end

      def default_event_types
        @default_event_types ||= []
      end

      def providers
        @providers ||= Hash.new { |h, k| h[k] = [] }
      end

      def map(&_block)
        yield self
      end

      # Registers an activity provider
      def register(event_type, options = {})
        options.assert_valid_keys(:class_name, :default)

        event_type = event_type.to_s
        providers = options[:class_name] || event_type.classify
        providers = ([] << providers) unless providers.is_a?(Array)

        available_event_types << event_type unless available_event_types.include?(event_type)
        default_event_types << event_type unless default_event_types.include?(event_type) || options[:default] == false
        self.providers[event_type] += providers
      end
    end
  end
end
