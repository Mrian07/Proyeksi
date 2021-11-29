

module JournalFormatter
  class Id < Attribute
    def format_values(values)
      values.map { |v| "##{v}" }
    end
  end
end
