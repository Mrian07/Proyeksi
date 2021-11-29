

require 'spec_helper'
require_relative './shared_contract_examples'

describe Projects::CreateContract do
  it_behaves_like 'project contract' do
    let(:project) do
      Project.new(name: project_name,
                  identifier: project_identifier,
                  description: project_description,
                  active: project_active,
                  public: project_public,
                  parent: project_parent,
                  status: project_status)
    end
    let(:permissions) { [:add_project] }
    let!(:allowed_to) do
      allow(current_user)
        .to receive(:allowed_to_globally?) do |permission|
          permissions.include?(permission)
        end
    end

    subject(:contract) { described_class.new(project, current_user) }

    context 'if the identifier is nil' do
      let(:project_identifier) { nil }

      it 'is replaced for new project' do
        expect_valid(true)
      end
    end
  end
end
