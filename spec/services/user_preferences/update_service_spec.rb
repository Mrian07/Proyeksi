#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_update_service'

describe UserPreferences::UpdateService, type: :model do
  it_behaves_like 'BaseServices update service' do
    let(:params_success) { true }
    let(:params_errors) { ActiveModel::Errors.new({}) }
    let(:params_contract) do
      instance_double(UserPreferences::ParamsContract, valid?: params_success, errors: params_errors)
    end

    before do
      allow(UserPreferences::ParamsContract).to receive(:new).and_return(params_contract)
    end

    context 'when the params contract is invalid' do
      let(:params_success) { false }

      it 'returns that error' do
        expect(subject).to be_failure
        expect(subject.errors).to eq(params_errors)
      end
    end
  end
end
