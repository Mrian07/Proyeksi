

require 'spec_helper'

require_relative '../shared_examples'

describe Bim::Bcf::API::V2_1::Auth::SingleRepresenter, 'rendering' do
  let(:instance) { described_class.new(nil) }
  include ProyeksiApp::StaticRouting::UrlHelpers

  subject { instance.to_json }

  describe 'attributes' do
    before do
      allow(ProyeksiApp::Configuration)
        .to receive(:rails_relative_url_root)
        .and_return('/blubs')
    end

    context 'oauth2_auth_url' do
      it_behaves_like 'attribute' do
        let(:value) { "http://localhost:3000/blubs/oauth/authorize" }
        let(:path) { 'oauth2_auth_url' }
      end
    end

    context 'oauth2_token_url' do
      it_behaves_like 'attribute' do
        let(:value) { "http://localhost:3000/blubs/oauth/token" }
        let(:path) { 'oauth2_token_url' }
      end
    end

    context 'http_basic_supported' do
      it_behaves_like 'attribute' do
        let(:value) { false }
        let(:path) { 'http_basic_supported' }
      end
    end

    context 'supported_oauth2_flows' do
      it_behaves_like 'attribute' do
        let(:value) { %w(authorization_code_grant client_credentials) }
        let(:path) { 'supported_oauth2_flows' }
      end
    end
  end
end
