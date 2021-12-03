#-- encoding: UTF-8

module WorkPackage::Exports
  class QueryExporter < Exports::Exporter
    self.model = WorkPackage

    alias :query :object

    attr_reader :column_objects, :columns, :work_packages

    def initialize(object, options = {})
      super

      @column_objects = get_columns
      @columns = column_objects.map { |c| { name: c.name, caption: c.caption } }
      @work_packages = get_work_packages
    end

    def get_columns
      query
        .columns
        .reject { |c| c.is_a?(Queries::WorkPackages::Columns::RelationColumn) }
    end

    def page
      options[:page] || 1
    end

    def get_work_packages
      query
        .results
        .work_packages
        .page(page)
        .per_page(Setting.work_packages_export_limit.to_i)
    end
  end
end
