

require 'spec_helper'

describe Notifications::Scopes::Visible, type: :model do
  describe '.visible' do
    subject(:scope) { ::Notification.visible(user) }

    let(:user) do
      FactoryBot.create(:user,
                        member_in_project: project,
                        member_with_permissions: permissions)
    end

    let(:notification) do
      FactoryBot.create(:notification,
                        project: project,
                        resource: work_package,
                        recipient: notification_recipient)
    end
    let(:notification_recipient) { user }
    let(:permissions) { %i[view_work_packages] }
    let(:project) { FactoryBot.create(:project) }
    let(:work_package) { FactoryBot.create(:work_package, project: project) }

    let!(:notifications) { notification }

    shared_examples_for 'is empty' do
      it 'is empty' do
        expect(scope)
          .to be_empty
      end
    end

    context 'with the user being recipient and being allowed to see the work package' do
      it 'returns the notification' do
        expect(scope)
          .to match_array([notification])
      end
    end

    context 'with the user being recipient and not being allowed to see the work package' do
      let(:permissions) { [] }

      it_behaves_like 'is empty'
    end

    context 'with the user not being recipient but being allowed to see the work package' do
      let(:notification_recipient) { FactoryBot.create(:user) }

      it_behaves_like 'is empty'
    end
  end
end
