#-- encoding: UTF-8

module Queries::Copy
  class FiltersMapper
    attr_reader :state, :filters, :mappers

    def initialize(state, filters)
      @state = state
      @filters = filters
      @mappers = build_filter_mappers
    end

    ##
    # Returns the mapped filter array for either
    # hash-based APIv3 filters or filter clasess
    def map_filters!
      filters.each do |filter|
        if filter.is_a?(Hash)
          map_api_filter_hash(filter)
        else
          map_filter_class(filter)
        end
      end

      filters
    end

    protected

    ##
    # Maps an API v3 filter hash
    # e.g.,
    # { parent: { operator: '=', values: [1234] } }
    def map_api_filter_hash(filter)
      name = filter.keys.first
      subhash = filter[name]
      ar_name = ::API::Utilities::QueryFiltersNameConverter.to_ar_name(name, refer_to_ids: true)

      subhash['values'] = mapped_values(ar_name, subhash['values'])
    end

    def map_filter_class(filter)
      filter.values = mapped_values(filter.name, filter.values)
    end

    def mapped_values(ar_name, values)
      mapper = mappers[ar_name.to_sym]

      mapper&.call(values) || values
    end

    def build_filter_mappers
      {
        version_id: state_mapper(:version_id_lookup),
        category_id: state_mapper(:category_id_lookup),
        parent: state_mapper(:work_package_id_lookup)
      }
    end

    def state_mapper(lookup_key)
      ->(values) do
        lookup = state.send(lookup_key)
        next unless lookup.is_a?(Hash)

        values.map { |id| (lookup[id.to_i] || id).to_s }
      end
    end
  end
end
