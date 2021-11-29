#-- encoding: UTF-8



module Queries::Filters::Strategies
  module IntegerNumeric
    private

    def numeric_class
      ::Integer
    end

    def error_message
      :not_an_integer
    end
  end
end
