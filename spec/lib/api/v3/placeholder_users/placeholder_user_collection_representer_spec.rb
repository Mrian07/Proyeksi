

require 'spec_helper'

describe ::API::V3::PlaceholderUsers::PlaceholderUserCollectionRepresenter do
  let(:self_base_link) { '/api/v3/placeholder_users' }
  let(:collection_inner_type) { 'PlaceholderUser' }
  let(:total) { 3 }
  let(:page) { 1 }
  let(:page_size) { 2 }
  let(:actual_count) { 3 }
  let(:current_user) { FactoryBot.build_stubbed :user }

  let(:placeholders) do
    placeholders = FactoryBot.build_stubbed_list(:placeholder_user,
                                          actual_count)
    allow(placeholders)
      .to receive(:per_page)
      .with(page_size)
      .and_return(placeholders)

    allow(placeholders)
      .to receive(:page)
      .with(page)
      .and_return(placeholders)

    allow(placeholders)
      .to receive(:count)
      .and_return(total)

    placeholders
  end

  let(:representer) do
    described_class.new(placeholders,
                        self_link: self_base_link,
                        per_page: page_size,
                        page: page,
                        current_user: current_user)
  end

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'offset-paginated APIv3 collection'
  end
end
