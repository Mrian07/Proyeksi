#-- encoding: UTF-8

class CustomActions::Actions::AssignedTo < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::MeAssociated

  def self.key
    :assigned_to
  end

  def available_principles
    principal_class
      .not_locked
      .select(:id, :firstname, :lastname, :type)
      .ordered_by_name
      .map { |u| [u.id, u.name] }
  end

  def apply(work_package)
    work_package.assigned_to_id = transformed_value(values.first)
  end

  def principal_class
    Principal
  end
end
