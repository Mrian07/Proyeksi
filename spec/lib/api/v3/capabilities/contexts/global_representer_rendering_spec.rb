

require 'spec_helper'

describe ::API::V3::Capabilities::Contexts::GlobalRepresenter, 'rendering' do
  include ::API::V3::Utilities::PathHelper

  subject { representer.to_json }

  let(:representer) do
    described_class
      .create(nil,
              current_user: nil,
              embed_links: true)
  end

  describe '_links' do
    describe 'self' do
      it_behaves_like 'has an untitled link' do
        let(:link) { 'self' }
        let(:href) { api_v3_paths.capabilities_contexts_global }
      end
    end
  end

  describe 'properties' do
    it_behaves_like 'property', :_type do
      let(:value) { 'CapabilityContext' }
    end

    it_behaves_like 'property', :id do
      let(:value) { 'global' }
    end
  end
end
