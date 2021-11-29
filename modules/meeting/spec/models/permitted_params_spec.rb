

require File.dirname(__FILE__) + '/../spec_helper'

describe PermittedParams, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }

  describe '#search' do
    it 'permits its whitelisted params' do
      acceptable_params = { messages: 1 }

      permitted = ActionController::Parameters.new(acceptable_params).permit!
      params = ActionController::Parameters.new(acceptable_params)

      expect(PermittedParams.new(params, user).search).to eq(permitted)
    end
  end
end
