

require 'spec_helper'

require_relative '../shared_examples'

describe Bim::Bcf::API::V2_1::Users::SingleRepresenter, 'rendering' do
  let(:user) { FactoryBot.build_stubbed(:user) }

  let(:instance) { described_class.new(user) }

  subject { instance.to_json }

  describe 'attributes' do
    context 'id' do
      it_behaves_like 'attribute' do
        let(:value) { user.mail }
        let(:path) { 'id' }
      end
    end

    context 'name' do
      it_behaves_like 'attribute' do
        let(:value) { user.name }
        let(:path) { 'name' }
      end
    end
  end
end
