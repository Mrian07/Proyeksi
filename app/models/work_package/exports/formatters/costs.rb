#-- encoding: UTF-8

module WorkPackage::Exports
  module Formatters
    class Costs < ::Exports::Formatters::Default
      def self.apply?(column)
        column.is_a? ::Costs::QueryCurrencyColumn
      end

      def format_options
        { number_format: number_format_string }
      end

      def number_format_string
        # [$CUR] makes sure we have an actually working currency format with arbitrary currencies
        curr = "[$CUR]".gsub "CUR", ERB::Util.h(Setting.plugin_costs['costs_currency'])
        format = ERB::Util.h Setting.plugin_costs['costs_currency_format']
        number = '#,##0.00'

        format.gsub("%n", number).gsub("%u", curr)
      end
    end
  end
end
