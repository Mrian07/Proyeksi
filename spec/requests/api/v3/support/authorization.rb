

require 'spec_helper'

shared_examples_for 'handling anonymous user' do
  context 'anonymous user' do
    before do
      allow(User).to receive(:current).and_return(User.anonymous)
    end

    context 'when access for anonymous user is not allowed' do
      before do
        allow(Setting).to receive(:login_required?).and_return(true)
        get path
      end

      it_behaves_like 'unauthenticated access'
    end
  end
end
