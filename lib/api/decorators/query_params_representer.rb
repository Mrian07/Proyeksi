# Other than the Roar based representers of the api v3, this
# representer is only responsible for transforming a query's
# attributes into a hash which in turn can be used e.g. to be displayed
# in a url

module API
  module Decorators
    class QueryParamsRepresenter
      def initialize(query)
        self.query = query
      end

      ##
      # To json hash outputs the hash to be parsed to the frontend http
      # which contains a reference to the columns array as columns[].
      # This will match the Rails +to_query+ output
      def to_json(*_args)
        to_h.to_json
      end

      def to_h(*args)
        p = default_hash

        p[:sortBy] = orders_to_v3 if query.ordered?

        # an empty filter param is also relevant as this would mean to not apply
        # the default filter (status - open)
        p[:filters] = filters_to_v3

        p
      end

      private

      def orders_to_v3
        converted = query.orders.map { |order| [convert_to_v3(order.attribute), order.direction] }

        JSON::dump(converted)
      end

      def filters_to_v3
        converted = query.filters.map do |filter|
          { convert_to_v3(filter.name) => { operator: filter.operator, values: filter.values } }
        end

        JSON::dump(converted)
      end

      def convert_to_v3(attribute)
        ::API::Utilities::PropertyNameConverter.from_ar_name(attribute).to_sym
      end

      def default_hash
        { offset: 1, pageSize: Setting.per_page_options_array.first }
      end

      attr_accessor :query
    end
  end
end
