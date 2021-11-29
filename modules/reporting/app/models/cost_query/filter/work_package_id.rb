

class CostQuery::Filter::WorkPackageId < Report::Filter::Base
  def self.label
    WorkPackage.model_name.human
  end

  def self.available_values(*)
    WorkPackage
      .where(project_id: Project.allowed_to(User.current, :view_work_packages))
      .order(:id)
      .pluck(:id, :subject)
      .map { |id, subject| [text_for_tuple(id, subject), id] }
  end

  def self.available_operators
    ['='].map(&:to_operator)
  end

  ##
  # Overwrites Report::Filter::Base self.label_for_value method
  # to achieve a more performant implementation
  def self.label_for_value(value)
    return nil unless value.to_i.to_s == value.to_s # we expect an work_package-id

    work_package = WorkPackage.find(value.to_i)
    [text_for_work_package(work_package), work_package.id] if work_package and work_package.visible?(User.current)
  end

  def self.text_for_tuple(id, subject)
    str = "##{id} "
    str << (subject.length > 30 ? subject.first(26) + '...' : subject)
  end

  def self.text_for_work_package(i)
    i = i.first if i.is_a? Array
    text_for_touble(i.id, i.subject)
  end
end
