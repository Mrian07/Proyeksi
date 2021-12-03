#-- encoding: UTF-8

class WorkPackageCustomField < CustomField
  has_and_belongs_to_many :projects,
                          join_table: "#{table_name_prefix}custom_fields_projects#{table_name_suffix}",
                          foreign_key: 'custom_field_id'
  has_and_belongs_to_many :types,
                          join_table: "#{table_name_prefix}custom_fields_types#{table_name_suffix}",
                          foreign_key: 'custom_field_id'
  has_many :work_packages,
           through: :work_package_custom_values

  scope :visible_by_user, ->(user) {
    if user.allowed_to_globally?(:select_custom_fields)
      all
    else
      where(projects: { id: Project.visible(user) })
        .where(types: { id: Type.enabled_in(Project.visible(user)) })
        .or(where(is_for_all: true).references(:projects, :types))
        .includes(:projects, :types)
    end
  }

  def self.summable
    where(field_format: %w[int float])
  end

  def summable?
    %w[int float].include?(field_format)
  end

  def type_name
    :label_work_package_plural
  end
end
