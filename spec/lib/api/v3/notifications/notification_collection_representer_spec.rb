

require 'spec_helper'

describe ::API::V3::Notifications::NotificationCollectionRepresenter do
  let(:self_base_link) { '/api/v3/notifications' }
  let(:user) { FactoryBot.build_stubbed :user }
  let(:notifications) do
    FactoryBot.build_stubbed_list(:notification,
                                  3).tap do |items|
      allow(items)
        .to receive(:per_page)
              .with(page_size)
              .and_return(items)

      allow(items)
        .to receive(:page)
              .with(page)
              .and_return(items)

      allow(items)
        .to receive(:count)
              .and_return(total)
    end
  end
  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:representer) do
    described_class.new(notifications,
                        self_link: self_base_link,
                        per_page: page_size,
                        page: page,
                        groups: groups,
                        current_user: current_user)
  end
  let(:total) { 3 }
  let(:page) { 1 }
  let(:page_size) { 2 }
  let(:actual_count) { 3 }
  let(:collection_inner_type) { 'Notification' }
  let(:groups) { nil }

  include API::V3::Utilities::PathHelper

  before do
    allow(API::V3::Notifications::NotificationEagerLoadingWrapper)
      .to receive(:wrap)
            .with(notifications)
            .and_return(notifications)
  end

  describe 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'offset-paginated APIv3 collection', 3, 'notifications', 'Notification'

    context 'when passing groups' do
      let(:groups) do
        [
          { value: 'mentioned', count: 34 },
          { value: 'involved', count: 5 }
        ]
      end

      it 'renders the groups object as json' do
        expect(subject).to be_json_eql(groups.to_json).at_path('groups')
      end
    end
  end
end
