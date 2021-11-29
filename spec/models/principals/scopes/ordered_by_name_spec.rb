#-- encoding: UTF-8



require 'spec_helper'

describe Principals::Scopes::OrderedByName, type: :model do
  describe '.ordered_by_name' do
    shared_let(:alice) { FactoryBot.create(:user, login: 'alice', firstname: 'Alice', lastname: 'Zetop') }
    shared_let(:eve) { FactoryBot.create(:user, login: 'eve', firstname: 'Eve', lastname: 'Baddie') }

    shared_let(:group) { FactoryBot.create(:group, name: 'Core Team') }
    shared_let(:placeholder_user) { FactoryBot.create(:placeholder_user, name: 'Developers') }

    subject { Principal.ordered_by_name(desc: descending).pluck(:id) }

    let(:descending) { false }

    shared_examples 'sorted results' do
      it 'returns the correct ascending sort' do
        expect(subject).to eq order
      end

      context 'reversed' do
        let(:descending) { true }

        it 'returns the correct descending sort' do
          expect(subject).to eq order.reverse
        end
      end
    end

    context 'with default user sort', with_settings: { user_format: :firstname_lastname } do
      it_behaves_like 'sorted results' do
        let(:order) { [alice.id, group.id, placeholder_user.id, eve.id] }
      end
    end

    context 'with lastname_firstname user sort', with_settings: { user_format: :lastname_firstname } do
      it_behaves_like 'sorted results' do
        let(:order) { [eve.id, group.id, placeholder_user.id, alice.id] }
      end
    end

    context 'with lastname_coma_firstname user sort', with_settings: { user_format: :lastname_coma_firstname } do
      it_behaves_like 'sorted results' do
        let(:order) { [eve.id, group.id, placeholder_user.id, alice.id] }
      end
    end

    context 'with firstname user sort', with_settings: { user_format: :firstname } do
      it_behaves_like 'sorted results' do
        let(:order) { [alice.id, group.id, placeholder_user.id, eve.id] }
      end
    end

    context 'with login user sort', with_settings: { user_format: :username } do
      it_behaves_like 'sorted results' do
        let(:order) { [alice.id, group.id, placeholder_user.id, eve.id] }
      end
    end
  end
end
