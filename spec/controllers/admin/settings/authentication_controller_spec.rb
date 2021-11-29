

require 'spec_helper'

describe Admin::Settings::AuthenticationSettingsController, type: :controller do
  describe 'show.html' do
    def fetch
      get 'show'
    end

    it_behaves_like 'a controller action with require_admin'
  end
end
