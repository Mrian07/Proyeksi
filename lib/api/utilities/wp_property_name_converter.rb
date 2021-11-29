#-- encoding: UTF-8



require 'api/utilities/property_name_converter'
require 'api/utilities/property_name_converter_work_package_dummy'

module API
  module Utilities
    class WpPropertyNameConverter
      class << self
        def to_ar_name(attribute, refer_to_ids: false)
          conversion_wp = ::API::Utilities::PropertyNameConverterWorkPackageDummy.new

          ::API::Utilities::PropertyNameConverter.to_ar_name(attribute,
                                                             context: conversion_wp,
                                                             refer_to_ids: refer_to_ids)
        end
      end
    end
  end
end
