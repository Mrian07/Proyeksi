

require 'spec_helper'
require_relative './shared_contract_examples'

describe Projects::UpdateContract do
  it_behaves_like 'project contract' do
    let(:project) do
      FactoryBot.build_stubbed(:project,
                               active: project_active,
                               public: project_public,
                               status: project_status).tap do |p|
        # in order to actually have something changed
        p.name = project_name
        p.parent = project_parent
        p.identifier = project_identifier
      end
    end
    let(:permissions) { [:edit_project] }

    subject(:contract) { described_class.new(project, current_user) }

    context 'if the identifier is nil' do
      let(:project_identifier) { nil }

      it 'is replaced for new project' do
        expect_valid(false, identifier: %i(blank))
      end
    end
  end
end
