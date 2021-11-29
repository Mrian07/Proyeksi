

module JournalFormatter
  class Plaintext < Attribute
    def format_values(values)
      values.map { |v| v.try(:to_s) }
    end
  end
end
