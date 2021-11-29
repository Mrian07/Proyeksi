#-- encoding: UTF-8



require 'spec_helper'

describe Principals::Scopes::Like, type: :model do
  describe '.like' do
    let!(:login) do
      FactoryBot.create(:principal, login: 'login')
    end
    let!(:login2) do
      FactoryBot.create(:principal, login: 'login2')
    end
    let!(:firstname) do
      FactoryBot.create(:principal, firstname: 'firstname')
    end
    let!(:firstname2) do
      FactoryBot.create(:principal, firstname: 'firstname2')
    end
    let!(:lastname) do
      FactoryBot.create(:principal, lastname: 'lastname')
    end
    let!(:lastname2) do
      FactoryBot.create(:principal, lastname: 'lastname2')
    end
    let!(:mail) do
      FactoryBot.create(:principal, mail: 'mail@example.com')
    end
    let!(:mail2) do
      FactoryBot.create(:principal, mail: 'mail2@example.com')
    end

    it 'finds by login' do
      expect(Principal.like('login'))
        .to match_array [login, login2]
    end

    it 'finds by firstname' do
      expect(Principal.like('firstname'))
        .to match_array [firstname, firstname2]
    end

    it 'finds by lastname' do
      expect(Principal.like('lastname'))
        .to match_array [lastname, lastname2]
    end

    it 'finds by mail' do
      expect(Principal.like('mail'))
        .to match_array [mail, mail2]
    end
  end
end
