

module JournalFormatter
  class Fraction < Attribute
    include ActionView::Helpers::NumberHelper

    def format_values(values)
      values.map do |v|
        if v.nil?
          nil
        else
          number_with_precision(v.to_f, precision: 2)
        end
      end
    end
  end
end
