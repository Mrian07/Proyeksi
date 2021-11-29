

require 'spec_helper'

describe ::API::V3::Projects::Statuses::StatusRepresenter, 'rendering' do
  include ::API::V3::Utilities::PathHelper

  subject { representer.to_json }

  let(:status) { Projects::Status.codes.keys.first }
  let(:representer) do
    described_class.create(status, current_user: current_user, embed_links: true)
  end

  current_user { FactoryBot.build_stubbed(:user) }

  describe '_links' do
    describe 'self' do
      it_behaves_like 'has a titled link' do
        let(:link) { 'self' }
        let(:href) { api_v3_paths.project_status status }
        let(:title) { I18n.t(:"activerecord.attributes.projects/status.codes.#{status}") }
      end
    end
  end

  describe 'properties' do
    it_behaves_like 'property', :_type do
      let(:value) { 'ProjectStatus' }
    end

    it_behaves_like 'property', :id do
      let(:value) { status }
    end

    it_behaves_like 'property', :name do
      let(:value) { I18n.t(:"activerecord.attributes.projects/status.codes.#{status}") }
    end
  end
end
