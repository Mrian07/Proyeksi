#-- encoding: UTF-8



module API
  module V3
    module Queries
      module SortBys
        class SortByDecorator
          def initialize(column, direction)
            if !['asc', 'desc'].include?(direction)
              raise ArgumentError, "Invalid direction. Only 'asc' and 'desc' are supported."
            end

            if column.nil?
              raise ArgumentError, "Column needs to be set"
            end

            self.direction = direction
            self.column = column
          end

          def id
            "#{converted_name}-#{direction_name}"
          end

          def name
            I18n.t('query.attribute_and_direction',
                   attribute: column_caption,
                   direction: direction_l10n)
          end

          def converted_name
            convert_attribute(column_name)
          end

          def direction_name
            direction
          end

          def direction_uri
            "#{API::V3::URN_PREFIX}queries:directions:#{direction}"
          end

          def direction_l10n
            I18n.t(direction == 'desc' ? :label_descending : :label_ascending)
          end

          def column_name
            column.name
          end

          def column_caption
            column.caption
          end

          private

          def convert_attribute(attribute)
            ::API::Utilities::PropertyNameConverter.from_ar_name(attribute)
          end

          attr_accessor :direction, :column
        end
      end
    end
  end
end
