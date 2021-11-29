#-- encoding: UTF-8



require 'spec_helper'

describe Users::Scopes::FindByLogin, type: :model do
  let!(:activity) { FactoryBot.create(:time_entry_activity) }
  let!(:project) { FactoryBot.create(:project) }
  let!(:user) { FactoryBot.create(:user, login: login) }
  let(:login) { 'Some string' }
  let(:search_login) { login }

  describe '.find_by_login' do
    subject { User.find_by_login(search_login) }

    context 'with the exact same login' do
      it 'returns the user' do
        expect(subject)
          .to eql user
      end
    end

    context 'with a non existing login' do
      let(:search_login) { 'nothing' }

      it 'returns nil' do
        expect(subject)
          .to be_nil
      end
    end

    context 'with a lowercase login' do
      let(:search_login) { login.downcase }

      it 'returns the user with the matching login' do
        expect(subject)
          .to eql user
      end
    end
  end
end
