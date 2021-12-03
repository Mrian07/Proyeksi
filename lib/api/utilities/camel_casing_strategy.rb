#-- encoding: UTF-8

# Temporarily solution!
# Using customized version of Representable gem (git@github.com:finnlabs/representable.git)
# we can specify strategy to take place during the data serialization

module API
  module Utilities
    class CamelCasingStrategy
      # CamelCase properties of ROAR representer
      def call(property)
        to_camel_case(property)
      end

      private

      def to_camel_case(string)
        return string if string.first == '_'

        string.camelize(:lower)
      end
    end
  end
end
