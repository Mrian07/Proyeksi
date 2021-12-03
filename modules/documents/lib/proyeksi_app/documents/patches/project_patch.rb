

module ProyeksiApp::Documents::Patches
  module ProjectPatch
    def self.included(base)
      base.class_eval do
        has_many :documents, dependent: :destroy
      end
    end
  end
end

Project.include ProyeksiApp::Documents::Patches::ProjectPatch
