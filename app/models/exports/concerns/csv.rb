#-- encoding: UTF-8

module Exports
  module Concerns
    module CSV
      def export!
        serialized = ::CSV.generate(col_sep: I18n.t(:general_csv_separator)) do |csv|
          headers = csv_headers
          csv << encode_csv_columns(headers)

          records.each do |record|
            row = csv_row(record)
            csv << encode_csv_columns(row)
          end
        end

        success(serialized)
      end

      def encode_csv_columns(columns, encoding = I18n.t(:general_csv_encoding))
        columns.map do |cell|
          Redmine::CodesetUtil.from_utf8(cell.to_s, encoding)
        end
      end

      def success(serialized)
        ::Exports::Result
          .new format: :csv,
               title: csv_export_filename,
               content: serialized,
               mime_type: 'text/csv'
      end

      # fetch all headers
      def csv_headers
        headers = columns.pluck(:caption)

        # because of
        # https://support.microsoft.com/en-us/help/323626/-sylk-file-format-is-not-valid-error-message-when-you-open-file
        if headers[0].start_with?('ID')
          headers[0] = headers[0].downcase
        end

        headers
      end

      # fetch all row values
      def csv_row(record)
        columns.collect do |column|
          format_csv(record, column[:name])
        end
      end

      def format_csv(record, attribute)
        format_attribute(record, attribute, array_separator: '; ')
      end

      def csv_export_filename
        sane_filename(
          "#{Setting.app_title} #{title} \
          #{format_time_as_date(Time.zone.now, '%Y-%m-%d')}.csv"
        )
      end
    end
  end
end
