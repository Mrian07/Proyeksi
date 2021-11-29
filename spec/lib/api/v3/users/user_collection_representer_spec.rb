

require 'spec_helper'

describe ::API::V3::Users::UserCollectionRepresenter do
  let(:users) do
    FactoryBot.build_stubbed_list(:user,
                                  3)
  end
  let(:representer) do
    described_class.new(users,
                        self_link: '/api/v3/work_package/1/watchers',
                        current_user: users.first)
  end

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'unpaginated APIv3 collection', 3, 'work_package/1/watchers', 'User'
  end
end
