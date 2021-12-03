#-- encoding: UTF-8

module Queries::Filters::Strategies
  module FloatNumeric
    private

    def numeric_class
      ::Float
    end

    def error_message
      :not_a_float
    end
  end
end
