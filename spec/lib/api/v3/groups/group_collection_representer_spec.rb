

require 'spec_helper'

describe ::API::V3::Groups::GroupCollectionRepresenter do
  let(:self_base_link) { '/api/v3/groups' }
  let(:groups) do
    FactoryBot.build_stubbed_list(:group, 3).tap do |groups|
      allow(groups)
        .to receive(:per_page)
        .with(page_size)
        .and_return(groups)

      allow(groups)
        .to receive(:page)
        .with(page)
        .and_return(groups)

      allow(groups)
        .to receive(:count)
        .and_return(total)
    end
  end
  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:representer) do
    described_class.new(groups,
                        self_link: self_base_link,
                        per_page: page_size,
                        page: page,
                        current_user: current_user)
  end
  let(:total) { 3 }
  let(:page) { 1 }
  let(:page_size) { 2 }
  let(:actual_count) { 3 }
  let(:collection_inner_type) { 'Group' }

  include API::V3::Utilities::PathHelper

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'offset-paginated APIv3 collection', 3, 'groups', 'Group'
  end
end
