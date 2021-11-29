

require 'spec_helper'

describe 'attachments routing', type: :request do
  describe 'for backwards compatibility' do
    it 'redirects GET attachments/:id to api v3 attachments/:id/content' do
      get "/attachments/1"
      expect(last_response).to be_redirect
      expect(last_response.location).to end_with("/api/v3/attachments/1/content")
    end

    it 'redirects GET attachments/:id/filename.ext to api v3 attachments/:id/content' do
      get "/attachments/1/filename.ext"
      expect(last_response).to be_redirect
      expect(last_response.location).to end_with("/api/v3/attachments/1/content")
    end

    it 'redirects DELETE attachments/:id to api v3 attachments/:id' do
      delete "/attachments/1"
      expect(last_response).to be_redirect
      expect(last_response.location).to end_with("/api/v3/attachments/1")
    end

    it 'redirects GET /attachments/download with filename to attachments#download' do
      get '/attachments/download/42/foo.png'

      expect(last_response).to be_redirect
      expect(last_response.location).to end_with '/attachments/42/foo.png'
    end

    it 'redirects GET /attachments/download without filename to attachments#download' do
      get '/attachments/download/42'

      expect(last_response).to be_redirect
      expect(last_response.location).to end_with '/attachments/42'
    end
  end
end
