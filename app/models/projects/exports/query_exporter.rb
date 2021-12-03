#-- encoding: UTF-8

module Projects::Exports
  class QueryExporter < Exports::Exporter
    self.model = Project

    alias :query :object

    def columns
      @columns ||= (forced_columns + selected_columns)
    end

    def page
      options[:page] || 1
    end

    def projects
      @projects ||= query
                      .results
                      .with_required_storage
                      .with_latest_activity
                      .includes(:custom_values, :status)
                      .page(page)
                      .per_page(Setting.work_packages_export_limit.to_i)
    end

    private

    def forced_columns
      [
        { name: :id, caption: Project.human_attribute_name(:id) },
        { name: :identifier, caption: Project.human_attribute_name(:identifier) },
        { name: :name, caption: Project.human_attribute_name(:name) }
      ]
    end

    def selected_columns
      ::Projects::TableCell
        .new(nil, current_user: User.current)
        .all_columns
        .reject { |_, options| options[:builtin] } # We add builtin columns ourselves
        .select { |name, _| Setting.enabled_projects_columns.include?(name.to_s) }
        .map { |name, options| { name: name, caption: options[:caption] } }
    end
  end
end
