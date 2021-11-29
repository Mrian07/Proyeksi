#-- encoding: UTF-8



class ProjectCustomField < CustomField
  def type_name
    :label_project_plural
  end

  def self.visible(user = User.current)
    if user.admin?
      all
    else
      where(visible: true)
    end
  end
end
