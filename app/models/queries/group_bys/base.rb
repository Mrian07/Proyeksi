#-- encoding: UTF-8

module Queries
  module GroupBys
    class Base
      include ActiveModel::Validations

      def self.i18n_scope
        :activerecord
      end

      class_attribute :model
      attr_accessor :attribute

      def initialize(attribute)
        self.attribute = attribute
      end

      def self.key
        raise NotImplementedError
      end

      def association_class
        nil
      end

      def scope
        scope = model
        scope = model.joins(joins) if joins
        group_by scope
      end

      def name
        attribute
      end

      def joins
        nil
      end

      # Default to the same key for order
      # as the one for group
      def order_key
        self.class.key
      end

      protected

      def group_by(scope)
        scope.group(name)
      end
    end
  end
end
