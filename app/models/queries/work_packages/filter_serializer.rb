#-- encoding: UTF-8

module Queries::WorkPackages::FilterSerializer
  extend Queries::Filters::AvailableFilters
  extend Queries::Filters::AvailableFilters::ClassMethods

  def self.load(serialized_filter_hash)
    return [] if serialized_filter_hash.nil?

    # yeah, dunno, but apparently '=' may have been serialized as a Syck::DefaultKey instance...
    yaml = serialized_filter_hash
             .gsub('!ruby/object:Syck::DefaultKey {}', '"="')

    (YAML.load(yaml) || {}).each_with_object([]) do |(field, options), array|
      options = options.with_indifferent_access
      filter = filter_for(field, no_memoization: true)
      filter.operator = options['operator']
      filter.values = options['values']
      array << filter
    end
  end

  def self.dump(filters)
    YAML.dump ((filters || []).map(&:to_hash).reduce(:merge) || {}).stringify_keys
  end

  def self.registered_filters
    Queries::Register.filters[Query]
  end
end
