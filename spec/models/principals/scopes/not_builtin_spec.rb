#-- encoding: UTF-8



require 'spec_helper'

describe Principals::Scopes::NotBuiltin, type: :model do
  describe '.not_builtin' do
    let!(:anonymous_user) { FactoryBot.create(:anonymous) }
    let!(:system_user) { FactoryBot.create(:system) }
    let!(:deleted_user) { FactoryBot.create(:deleted_user) }
    let!(:group) { FactoryBot.create(:group) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:placeholder_user) { FactoryBot.create(:placeholder_user) }

    subject { Principal.not_builtin }

    it 'returns only actual users and groups' do
      expect(subject)
        .to match_array [user, group, placeholder_user]
    end
  end
end
