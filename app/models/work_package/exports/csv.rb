#-- encoding: UTF-8

module WorkPackage::Exports
  class CSV < QueryExporter
    include ::Exports::Concerns::CSV

    alias :records :work_packages

    private

    def title
      query.new_record? ? I18n.t(:label_work_package_plural) : query.name
    end

    def csv_headers
      super + [WorkPackage.human_attribute_name(:description)]
    end

    # fetch all row values
    def csv_row(work_package)
      super.tap do |row|
        if row.any?
          row << if work_package.description
                   work_package.description.squish
                 else
                   ''
                 end
        end
      end
    end
  end
end
