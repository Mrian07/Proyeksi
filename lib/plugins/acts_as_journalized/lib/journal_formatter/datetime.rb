

module JournalFormatter
  class Datetime < Attribute
    def format_values(values)
      values.map do |v|
        if v.nil?
          nil
        else
          format_date(v.to_date)
        end
      end
    end
  end
end
