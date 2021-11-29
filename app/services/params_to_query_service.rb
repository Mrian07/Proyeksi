

class ParamsToQueryService
  attr_accessor :user,
                :query_class

  def initialize(model, user, query_class: nil)
    set_query_class(query_class, model)
    self.user = user
  end

  def call(params)
    query = new_query

    query = apply_filters(query, params)
    apply_order(query, params)
    apply_group_by(query, params)
  end

  private

  def new_query
    query_class.new(user: user)
  end

  def apply_filters(query, params)
    return query unless params[:filters]

    filters = parse_filters_from_json(params[:filters])

    filters[:attributes].each do |filter_name|
      query = query.where(filter_name,
                          filters[:operators][filter_name],
                          filters[:values][filter_name])
    end

    query
  end

  def apply_order(query, params)
    return query unless params[:sortBy]

    sort = parse_sorting_from_json(params[:sortBy])

    hash_sort = sort.each_with_object({}) do |(attribute, direction), hash|
      hash[attribute.to_sym] = direction.downcase.to_sym
    end

    query.order(hash_sort)
  end

  def apply_group_by(query, params)
    return query unless params[:groupBy]

    group_by = convert_attribute(params[:groupBy])

    query.group(group_by)
  end

  # Expected format looks like:
  # [
  #   {
  #     "filtered_field_name": {
  #       "operator": "a name for a filter operation",
  #       "values": ["values", "for the", "operation"]
  #     }
  #   },
  #   { /* more filters if needed */}
  # ]
  def parse_filters_from_json(json)
    filters = JSON.parse(json)
    operators = {}
    values = {}
    filters.each do |filter|
      attribute = filter.keys.first # there should only be one attribute per filter
      ar_attribute = convert_attribute attribute, append_id: true
      operators[ar_attribute] = filter[attribute]['operator']
      values[ar_attribute] = filter[attribute]['values']
    end

    {
      attributes: values.keys,
      operators: operators,
      values: values
    }
  end

  def parse_sorting_from_json(json)
    JSON.parse(json).map do |(attribute, order)|
      [convert_attribute(attribute), order]
    end
  end

  def convert_attribute(attribute, append_id: false)
    ::API::Utilities::PropertyNameConverter.to_ar_name(attribute,
                                                       context: conversion_model,
                                                       refer_to_ids: append_id)
  end

  def conversion_model
    @conversion_model ||= ::API::Utilities::QueryFiltersNameConverterContext.new(query_class)
  end

  def set_query_class(query_class, model)
    self.query_class = if query_class
                         query_class
                       else
                         model_name = model.name

                         "::Queries::#{model_name.pluralize}::#{model_name}Query".constantize
                       end
  end
end
