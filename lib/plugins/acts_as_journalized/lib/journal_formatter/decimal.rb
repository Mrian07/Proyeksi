

module JournalFormatter
  class Decimal < Attribute
    def format_values(values)
      values.map { |v| v.to_i.to_s }
    end
  end
end
