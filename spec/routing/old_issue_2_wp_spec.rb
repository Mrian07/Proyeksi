

require 'spec_helper'

describe 'routes for old issue uris', type: :request do
  # These are routing specs and should be moved to
  # spec/routing.
  # As redirect_to is not supported by routing specs they have
  # to be marked as type request. However, this breaks when
  # moving them to spec/routing.
  describe 'for index action' do
    before do
      get('/issues')
    end

    it do
      expect(last_response).to be_redirect
      expect(last_response.location).to end_with '/work_packages'
    end
  end

  describe 'with specific id' do
    before do
      get('/issues/1234')
    end

    it do
      expect(last_response).to be_redirect
      expect(last_response.location).to end_with '/work_packages/1234'
    end
  end
end
