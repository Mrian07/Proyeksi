

require 'spec_helper'

describe Projects::SetAttributesService, 'integration', type: :model do
  let(:user) do
    FactoryBot.create(:user, global_permissions: %w[add_project])
  end
  let(:contract) { Projects::CreateContract }
  let(:instance) { described_class.new(user: user, model: project, contract_class: contract) }
  let(:attributes) { {} }
  let(:project) { Project.new }
  let(:service_result) do
    instance.call(attributes)
  end

  describe 'with a project name starting with numbers' do
    let(:attributes) { { name: '100 Project A' } }

    it 'will create an identifier including the numbers' do
      expect(service_result).to be_success
      expect(service_result.result.identifier).to eq '100-project-a'
    end
  end

  describe 'with an existing project' do
    let(:existing_identifier) { 'my-new-project' }
    let!(:existing) { FactoryBot.create :project, identifier: existing_identifier }

    context 'and a new project with no identifier set' do
      let(:project) { Project.new name: 'My new project' }

      it 'will auto-correct the identifier' do
        expect(service_result).to be_success
        expect(service_result.result.identifier).to eq 'my-new-project-1'
      end
    end

    context 'and a new project with the same identifier set' do
      let(:project) { Project.new name: 'My new project', identifier: 'my-new-project' }

      it 'will result in an error' do
        expect(service_result).not_to be_success
        expect(service_result.result.identifier).to eq 'my-new-project'

        errors = service_result.errors.full_messages
        expect(errors).to eq ['Identifier has already been taken.']
      end
    end
  end
end
