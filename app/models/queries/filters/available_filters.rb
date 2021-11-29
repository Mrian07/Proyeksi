#-- encoding: UTF-8



require_dependency 'queries/filters'

module Queries
  module Filters
    module AvailableFilters
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def registered_filters
          ::Queries::Register.filters[self]
        end

        def find_registered_filter(key)
          registered_filters.detect do |f|
            f.key === key.to_sym
          end
        end
      end

      def available_filters
        uninitialized = registered_filters - already_initialized_filters

        uninitialized.each do |filter|
          initialize_filter(filter)
        end

        initialized_filters.select(&:available?)
      end

      def filter_for(key, no_memoization: false)
        filter = get_initialized_filter(key, no_memoization)

        raise ::Queries::Filters::MissingError if filter.nil?

        filter
      rescue ::Queries::Filters::InvalidError => e
        Rails.logger.error "Failed to register filter for #{key}: #{e} \n" \
                           "Falling back to non-existing filter."
        non_existing_filter(key)
      rescue ::Queries::Filters::MissingError => e
        Rails.logger.error "Failed to find filter for #{key}: #{e} \n" \
                           "Falling back to non-existing filter."
        non_existing_filter(key)
      end

      private

      def non_existing_filter(key)
        ::Queries::Filters::NotExistingFilter.create!(name: key)
      end

      def get_initialized_filter(key, no_memoization)
        filter = find_registered_filter(key)

        return unless filter

        if no_memoization
          filter.create!(name: key)
        else
          initialize_filter(filter)

          find_initialized_filter(key)
        end
      end

      def initialize_filter(filter)
        return if already_initialized_filters.include?(filter)

        already_initialized_filters << filter

        new_filters = filter.all_for(context)

        initialized_filters.push(*Array(new_filters))
      end

      def find_registered_filter(key)
        self.class.find_registered_filter(key)
      end

      def find_initialized_filter(key)
        initialized_filters.detect do |f|
          f.name == key.to_sym
        end
      end

      def already_initialized_filters
        @already_initialized_filters ||= []
      end

      def initialized_filters
        @initialized_filters ||= []
      end

      def registered_filters
        self.class.registered_filters
      end
    end
  end
end
