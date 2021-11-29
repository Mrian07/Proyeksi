

require 'spec_helper'

describe ::API::V3::Memberships::MembershipCollectionRepresenter do
  let(:self_base_link) { '/api/v3/members' }
  let(:members) do
    FactoryBot.build_stubbed_list(:member, 3).tap do |members|
      allow(members)
        .to receive(:per_page)
        .with(page_size)
        .and_return(members)

      allow(members)
        .to receive(:page)
        .with(page)
        .and_return(members)

      allow(members)
        .to receive(:count)
        .and_return(3)
    end
  end
  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:representer) do
    described_class.new(members,
                        self_link: self_base_link,
                        per_page: page_size,
                        page: page,
                        current_user: current_user)
  end
  let(:total) { 3 }
  let(:page) { 1 }
  let(:page_size) { 2 }
  let(:actual_count) { 3 }
  let(:collection_inner_type) { 'Membership' }

  include API::V3::Utilities::PathHelper

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'offset-paginated APIv3 collection', 3, 'members', 'Membership'
  end
end
