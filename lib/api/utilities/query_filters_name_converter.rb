#-- encoding: UTF-8

require 'api/utilities/property_name_converter'
require 'api/utilities/query_filters_name_converter_context'

module API
  module Utilities
    class QueryFiltersNameConverter
      class << self
        def to_ar_name(attribute, refer_to_ids: false)
          conversion_wp = ::API::Utilities::QueryFiltersNameConverterContext.new

          ::API::Utilities::PropertyNameConverter.to_ar_name(attribute,
                                                             context: conversion_wp,
                                                             refer_to_ids: refer_to_ids)
        end
      end
    end
  end
end
