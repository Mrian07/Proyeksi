#-- encoding: UTF-8

module Queries
  module Orders
    module AvailableOrders
      def order_for(key)
        (find_registered_order(key) || ::Queries::Orders::NotExistingOrder).new(key)
      end

      private

      def find_registered_order(key)
        orders_register.detect do |s|
          s.key === key.to_sym
        end
      end

      def orders_register
        ::Queries::Register.orders[self.class]
      end
    end
  end
end
