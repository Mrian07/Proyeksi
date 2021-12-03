#-- encoding: UTF-8

module Projects::Exports
  class CSV < QueryExporter
    include ::Exports::Concerns::CSV

    alias :records :projects

    def title
      I18n.t(:label_project_plural)
    end
  end
end
