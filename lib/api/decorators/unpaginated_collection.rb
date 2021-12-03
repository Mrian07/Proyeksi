#-- encoding: UTF-8

module API
  module Decorators
    class UnpaginatedCollection < ::API::Decorators::Collection
      def initialize(models, self_link:, current_user:)
        super(models, model_count(models), self_link: self_link, current_user: current_user)
      end

      def model_count(models)
        if models.respond_to?(:except)
          # We do not want any order/selecting with counting
          # when it would result in an invalid SELECT COUNT(DISTINCT *, ).
          # As both, order and select should have no impact on the count result, we remove them.
          models.except(:select, :order)
        else
          models
        end.count
      end
    end
  end
end
