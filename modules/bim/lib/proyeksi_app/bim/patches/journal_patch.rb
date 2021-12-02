

require_dependency 'journal'

module ProyeksiApp::Bim::Patches::JournalPatch
  def self.included(base)
    base.class_eval do
      has_one :bcf_comment, class_name: 'Bim::Bcf::Comment', foreign_key: 'journal_id'
    end
  end
end
