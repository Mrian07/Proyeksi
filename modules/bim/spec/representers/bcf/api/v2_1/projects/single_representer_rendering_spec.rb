

require 'spec_helper'

require_relative '../shared_examples'

describe Bim::Bcf::API::V2_1::Projects::SingleRepresenter, 'rendering' do
  let(:project) { FactoryBot.build_stubbed(:project) }

  let(:instance) { described_class.new(project) }

  subject { instance.to_json }

  describe 'attributes' do
    context 'project_id' do
      it_behaves_like 'attribute' do
        let(:value) { project.id }
        let(:path) { 'project_id' }
      end
    end

    context 'name' do
      it_behaves_like 'attribute' do
        let(:value) { project.name }
        let(:path) { 'name' }
      end
    end
  end
end
