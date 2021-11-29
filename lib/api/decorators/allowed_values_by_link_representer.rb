#-- encoding: UTF-8



require 'roar/decorator'
require 'roar/json/hal'

module API
  module Decorators
    class AllowedValuesByLinkRepresenter < PropertySchemaRepresenter
      attr_accessor :allowed_values_href

      link :allowedValues do
        { href: allowed_values_href } if allowed_values_href
      end
    end
  end
end
