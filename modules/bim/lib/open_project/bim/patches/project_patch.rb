

require_dependency 'work_package'

module OpenProject::Bim::Patches::ProjectPatch
  def self.included(base)
    base.class_eval do
      has_many :ifc_models, class_name: 'Bim::IfcModels::IfcModel', foreign_key: 'project_id'
    end
  end
end
