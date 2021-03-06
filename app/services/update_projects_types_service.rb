#-- encoding: UTF-8

class UpdateProjectsTypesService < BaseProjectService
  def call(type_ids)
    type_ids = standard_types if type_ids.nil? || type_ids.empty?

    if types_missing?(type_ids)
      project.errors.add(:types,
                         :in_use_by_work_packages,
                         types: missing_types(type_ids).map(&:name).join(', '))
      false
    else
      project.type_ids = type_ids

      true
    end
  end

  protected

  def standard_types
    type = ::Type.standard_type
    if type.nil?
      []
    else
      [type.id]
    end
  end

  def types_missing?(type_ids)
    !missing_types(type_ids).empty?
  end

  def missing_types(type_ids)
    types_used_by_work_packages.select { |t| !type_ids.include?(t.id) }
  end

  def types_used_by_work_packages
    @types_used_by_work_packages ||= project.types_used_by_work_packages
  end
end
