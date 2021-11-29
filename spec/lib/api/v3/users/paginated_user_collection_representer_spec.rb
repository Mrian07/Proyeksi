

require 'spec_helper'

describe ::API::V3::Users::PaginatedUserCollectionRepresenter do
  let(:self_base_link) { '/api/v3/users' }
  let(:collection_inner_type) { 'User' }
  let(:total) { 3 }
  let(:page) { 1 }
  let(:page_size) { 2 }
  let(:actual_count) { 3 }

  let(:users) do
    users = FactoryBot.build_stubbed_list(:user,
                                          actual_count)
    allow(users)
      .to receive(:per_page)
      .with(page_size)
      .and_return(users)

    allow(users)
      .to receive(:page)
      .with(page)
      .and_return(users)

    allow(users)
      .to receive(:count)
      .and_return(total)

    users
  end

  let(:representer) do
    described_class.new(users,
                        self_link: '/api/v3/users',
                        per_page: page_size,
                        page: page,
                        current_user: users.first)
  end

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'offset-paginated APIv3 collection'
  end
end
