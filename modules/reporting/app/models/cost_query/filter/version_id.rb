

class CostQuery::Filter::VersionId < Report::Filter::Base
  use :null_operators
  join_table WorkPackage
  applies_for :label_work_package_attributes

  def self.label
    WorkPackage.human_attribute_name(:version)
  end

  def self.available_values(*)
    versions = Version.where(project_id: Project.visible.map(&:id))
    versions.map { |a| ["#{a.project.name} - #{a.name}", a.id] }.sort_by { |a| a.first.to_s + a.second.to_s }
  end
end
