#-- encoding: UTF-8

module Queries
  module Orders
    class Base
      include ActiveModel::Validations

      VALID_DIRECTIONS = %i(asc desc).freeze

      def self.i18n_scope
        :activerecord
      end

      validates :direction, inclusion: { in: VALID_DIRECTIONS }

      class_attribute :model
      attr_accessor :direction,
                    :attribute

      def initialize(attribute)
        self.attribute = attribute
      end

      def self.key
        raise NotImplementedError
      end

      def scope
        scope = order
        scope = scope.joins(joins) if joins
        scope = scope.left_outer_joins(left_outer_joins) if left_outer_joins
        scope
      end

      def name
        attribute
      end

      private

      def order
        model.order(name => direction)
      end

      def joins
        nil
      end

      def left_outer_joins
        nil
      end

      def with_raise_on_invalid
        if VALID_DIRECTIONS.include?(direction)
          yield
        else
          raise ArgumentError, "Only one of #{VALID_DIRECTIONS} allowed. #{direction} is provided."
        end
      end
    end
  end
end
