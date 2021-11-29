#-- encoding: UTF-8



require 'spec_helper'

describe IndividualPrincipalHooksHelper, type: :helper do
  let(:user) { FactoryBot.build(:user) }
  let(:placeholder_user) { FactoryBot.build(:placeholder_user) }

  describe '#individual_principal_key' do
    it 'returns the class name in underscore format' do
      expect(helper.individual_principal_key(user)).to eql(:user)
      expect(helper.individual_principal_key(placeholder_user)).to eql(:placeholder_user)
    end
  end

  describe '#call_individual_principals_memberships_hook' do
    context 'with user and without context' do
      before do
        expect(helper).to receive(:call_hook).with(:view_users_memberships_table_foo,
                                                   user: user)
      end

      it 'call call_hook with the correct arguments' do
        helper.call_individual_principals_memberships_hook(user, 'foo')
      end
    end

    context 'with placeholder user and without context' do
      before do
        expect(helper).to receive(:call_hook).with(:view_placeholder_users_memberships_table_foo,
                                                   placeholder_user: placeholder_user)
      end

      it 'call call_hook with the correct arguments' do
        helper.call_individual_principals_memberships_hook(placeholder_user, 'foo')
      end
    end

    context 'with user and with context' do
      before do
        expect(helper).to receive(:call_hook).with(:view_users_memberships_table_foo,
                                                   user: user,
                                                   yay: 'yo')
      end

      it 'call call_hook with the correct arguments' do
        helper.call_individual_principals_memberships_hook(user, 'foo', yay: 'yo')
      end
    end
  end
end
