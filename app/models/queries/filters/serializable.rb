#-- encoding: UTF-8

module Queries
  module Filters
    module Serializable
      include ActiveModel::Serialization
      extend ActiveSupport::Concern

      class_methods do
        # (de-)serialization
        def from_hash(filter_hash)
          filter_hash.keys.map do |field|
            create!(name, filter_hash[field])
          rescue ::Queries::Filters::InvalidError
            Rails.logger.error "Failed to constantize field filter #{field} from hash."
            ::Queries::Filters::NotExistingFilter.create!(field)
          end
        end
      end

      def to_hash
        { name => attributes_hash }
      end

      def attributes
        { name: name, operator: operator, values: values }
      end

      def ==(other)
        other.try(:attributes_hash) == attributes_hash
      end

      protected

      def attributes_hash
        self.class.filter_params.inject({}) do |params, param_field|
          params.merge(param_field => send(param_field))
        end
      end

      private

      def stringify_values
        unless values.nil?
          values.map!(&:to_s)
        end
      end
    end
  end
end
