#-- encoding: UTF-8

module API
  module Utilities
    module PageSizeHelper
      # Set a default max size to ensure backwards compatibility
      # with the previous private setting `maximum_page_size`.
      # The actual value is taken from
      # max(Setting.per_page_options)
      DEFAULT_API_MAX_SIZE ||= 500

      ##
      # Determine set page_size from string
      def resolve_page_size(string)
        resolved_value = to_i_or_nil(string)
        # a page size of 0 is a magic number for the maximum page size value
        if resolved_value == 0 || resolved_value.to_i > maximum_page_size
          resolved_value = maximum_page_size
        end
        resolved_value
      end

      ##
      # Determine the page size from the minimum of
      # * the provided value
      # * the page size specified for the relation (per_page)
      # * the minimum of the per page options specified in the settings
      # * the maximum page size
      def resulting_page_size(value, relation = nil)
        [value || relation&.base_class&.per_page || Setting.per_page_options_array.min, maximum_page_size]
          .map(&:to_i)
          .min
      end

      ##
      # Get the maximum allowed page size from
      # the largest option of per_page size,
      # or the magic fallback value 500.
      def maximum_page_size
        [
          DEFAULT_API_MAX_SIZE,
          Setting.per_page_options_array.max
        ].max
      end

      private

      def to_i_or_nil(string)
        string ? string.to_i : nil
      end
    end
  end
end
