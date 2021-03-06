#-- encoding: UTF-8

require_relative 'list_optional'

module Queries::Filters::Shared
  module CustomFields
    class User < ListOptional
      ##
      # User CFs may reference the 'me' value, so use the values helpers
      # from the Me mixin, which will override the ListOptional value_objects definition.
      include ::Queries::WorkPackages::Filter::MeValueFilterMixin

      def allowed_values
        @allowed_values ||= begin
                              me_allowed_value + super
                            end
      end
    end
  end
end
