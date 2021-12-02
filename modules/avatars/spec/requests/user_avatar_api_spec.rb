

require 'spec_helper'
require 'rack/test'

describe 'API v3 User avatar resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) { FactoryBot.create(:admin) }
  let(:other_user) { FactoryBot.create(:user) }

  subject(:response) { last_response }

  let(:setup) { nil }

  before do
    login_as current_user
  end

  describe '/avatar', with_settings: { protocol: 'http' } do
    before do
      allow(Setting)
        .to receive(:plugin_proyeksiapp_avatars)
        .and_return(enable_gravatars: gravatars, enable_local_avatars: local_avatars)

      setup

      get api_v3_paths.user(other_user.id) + "/avatar"
    end

    context 'with neither enabled' do
      let(:gravatars) { false }
      let(:local_avatars) { false }

      it 'renders a 404' do
        expect(response.status).to eq 404
      end
    end

    shared_examples_for 'cache headers set to 24 hours' do
      it 'has the cache headers set to 24 hours' do
        expect(response.headers["Cache-Control"]).to eq "public, max-age=86400"
        expect(response.headers["Expires"]).to be_present

        expires_time = Time.parse response.headers["Expires"]

        expect(expires_time < Time.now.utc + 86400).to be_truthy
        expect(expires_time > Time.now.utc + 86400 - 60).to be_truthy
      end
    end

    context 'when gravatar enabled' do
      let(:gravatars) { true }
      let(:local_avatars) { false }

      it 'redirects to gravatar' do
        expect(response.status).to eq 302
        expect(response.location).to match /gravatar\.com/
      end

      it_behaves_like 'cache headers set to 24 hours'
    end

    context 'with local avatar' do
      let(:gravatars) { true }
      let(:local_avatars) { true }

      let(:other_user) do
        u = FactoryBot.create :user
        u.attachments = [FactoryBot.build(:avatar_attachment, author: u)]
        u
      end

      it 'serves the attachment file' do
        expect(response.status).to eq 200
      end

      it_behaves_like 'cache headers set to 24 hours'

      context 'with external file storage (S3)' do
        let(:setup) do
          allow_any_instance_of(Attachment).to receive(:external_storage?).and_return true

          expect_any_instance_of(Attachment)
            .to receive(:external_url)
            .with(expires_in: 86400)
            .and_return("external URL")
        end

        # we test that Attachment#external_url works in `attachments_spec.rb`
        # so here we just make sue it's called accordingly when the external
        # storage is configured
        it 'redirects to temporary external URL' do
          expect(response.status).to eq 302
          expect(response.location).to eq "external URL"
        end
      end
    end
  end
end
