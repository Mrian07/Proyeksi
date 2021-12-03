module WorkPackage::AvailableCustomFields
  def self.for(project, type)
    project && type ? (project.all_work_package_custom_fields & type.custom_fields) : []
  end
end
