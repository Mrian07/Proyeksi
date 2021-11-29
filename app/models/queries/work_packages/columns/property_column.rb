#-- encoding: UTF-8



class Queries::WorkPackages::Columns::PropertyColumn < Queries::WorkPackages::Columns::WorkPackageColumn
  def caption
    WorkPackage.human_attribute_name(name)
  end

  class_attribute :property_columns

  self.property_columns = {
    id: {
      sortable: "#{WorkPackage.table_name}.id",
      groupable: false
    },
    project: {
      association: 'project',
      sortable: "name",
      groupable: "#{WorkPackage.table_name}.project_id"
    },
    subject: {
      sortable: "#{WorkPackage.table_name}.subject"
    },
    type: {
      association: 'type',
      sortable: "position",
      groupable: "#{WorkPackage.table_name}.type_id"
    },
    parent: {
      association: 'ancestors_relations',
      default_order: 'asc',
      sortable: false
    },
    status: {
      association: 'status',
      sortable: "position",
      highlightable: true,
      groupable: "#{WorkPackage.table_name}.status_id"
    },
    priority: {
      association: 'priority',
      sortable: "position",
      default_order: 'desc',
      highlightable: true,
      groupable: "#{WorkPackage.table_name}.priority_id"
    },
    author: {
      association: 'author',
      sortable: %w(lastname firstname id),
      groupable: "#{WorkPackage.table_name}.author_id"
    },
    assigned_to: {
      association: 'assigned_to',
      sortable: %w(lastname firstname id),
      groupable: "#{WorkPackage.table_name}.assigned_to_id"
    },
    responsible: {
      association: 'responsible',
      sortable: %w(lastname firstname id),
      groupable: "#{WorkPackage.table_name}.responsible_id"
    },
    updated_at: {
      sortable: "#{WorkPackage.table_name}.updated_at",
      default_order: 'desc'
    },
    category: {
      association: 'category',
      sortable: "name",
      groupable: "#{WorkPackage.table_name}.category_id"
    },
    version: {
      association: 'version',
      sortable: [->(table_name = Version.table_name) { Version.semver_sql(table_name) }, 'name'],
      default_order: 'ASC',
      null_handling: 'NULLS LAST',
      groupable: "#{WorkPackage.table_name}.version_id"
    },
    start_date: {
      sortable: "#{WorkPackage.table_name}.start_date",
      null_handling: 'NULLS LAST'
    },
    due_date: {
      highlightable: true,
      sortable: "#{WorkPackage.table_name}.due_date",
      null_handling: 'NULLS LAST'
    },
    estimated_hours: {
      sortable: "#{WorkPackage.table_name}.estimated_hours",
      summable: true
    },
    spent_hours: {
      sortable: false,
      summable: false
    },
    done_ratio: {
      sortable: "#{WorkPackage.table_name}.done_ratio",
      groupable: true,
      if: ->(*) { !WorkPackage.done_ratio_disabled? }
    },
    created_at: {
      sortable: "#{WorkPackage.table_name}.created_at",
      default_order: 'desc'
    }
  }

  def self.instances(_context = nil)
    property_columns.map do |name, options|
      next unless !options[:if] || options[:if].call

      new(name, options.except(:if))
    end.compact
  end
end
