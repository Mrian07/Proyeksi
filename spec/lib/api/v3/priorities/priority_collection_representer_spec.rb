

require 'spec_helper'

describe ::API::V3::Priorities::PriorityCollectionRepresenter do
  let(:priorities)  { FactoryBot.build_list(:priority, 3) }
  let(:representer) do
    described_class.new(priorities, self_link: '/api/v3/priorities', current_user: double('current_user'))
  end

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'unpaginated APIv3 collection', 3, 'priorities', 'Priority'
  end
end
