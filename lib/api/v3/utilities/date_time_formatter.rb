#-- encoding: UTF-8



module API
  module V3
    module Utilities
      class DateTimeFormatter
        def self.format_date(date, allow_nil: false)
          return nil if date.nil? && allow_nil

          date.to_date.iso8601
        end

        def self.parse_date(value, property_name, allow_nil: false)
          return nil if value.nil? && allow_nil

          date_and_time = parse_datetime(value, property_name, allow_nil: allow_nil)

          date_only = date_and_time.to_date

          # we only want to accept "timeless" dates, e.g. "2015-01-31",
          # but not "2015-01-31T01:02:03".
          # However Date.iso8601 is too generous and would accept that
          unless date_and_time == date_only
            raise API::Errors::PropertyFormatError.new(property_name,
                                                       I18n.t('api_v3.errors.expected.date'),
                                                       value)
          end

          date_only
        end

        def self.parse_datetime(value, property_name, allow_nil: false)
          return nil if value.nil? && allow_nil

          begin
            date_and_time = DateTime.iso8601(value)
          rescue ArgumentError
            raise API::Errors::PropertyFormatError.new(property_name,
                                                       I18n.t('api_v3.errors.expected.date'),
                                                       value)
          end

          date_and_time
        end

        def self.format_datetime(datetime, allow_nil: false)
          return nil if datetime.nil? && allow_nil

          datetime.to_datetime.utc.iso8601
        end

        def self.format_duration_from_hours(hours, allow_nil: false)
          return nil if hours.nil? && allow_nil

          Duration.new(seconds: hours * 3600).iso8601
        end

        def self.parse_duration_to_hours(duration, property_name, allow_nil: false)
          return nil if duration.nil? && allow_nil

          begin
            iso_duration = ISO8601::Duration.new(duration.to_s)
            iso_duration.to_seconds / 3600.0
          rescue ISO8601::Errors::UnknownPattern
            raise API::Errors::PropertyFormatError.new(property_name,
                                                       I18n.t('api_v3.errors.expected.duration'),
                                                       duration)
          end
        end
      end
    end
  end
end
