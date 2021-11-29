

require 'spec_helper'

describe ::Users::SetAttributesService, 'Integration', type: :model do
  let(:input_user) { FactoryBot.create(:user) }
  let(:actor) { FactoryBot.build_stubbed(:admin) }

  let(:instance) do
    described_class.new model: input_user,
                        user: actor,
                        contract_class: Users::UpdateContract
  end

  subject { instance.call(params) }

  context 'with a boolean castable preference' do
    let(:params) do
      { pref: { hide_mail: '0' } }
    end

    it 'returns an error for that' do
      expect(subject.errors).to be_empty
    end
  end

  context 'with an invalid parameter' do
    let(:params) do
      { pref: { workdays: 'foobar' } }
    end

    it 'returns an error for that' do
      expect(subject.errors[:workdays]).to include "is not of type 'array'"
    end
  end

  context 'with an unknown property' do
    let(:params) do
      { pref: { watwatwat: 'foobar' } }
    end

    it 'does not raise an error' do
      expect(subject).to be_success
      expect(subject.result.pref.settings).not_to be_key(:watwatwat)
    end
  end
end
