

require 'spec_helper'

describe ::API::V3::Posts::PostRepresenter, 'rendering' do
  include ::API::V3::Utilities::PathHelper

  let(:message) do
    FactoryBot.build_stubbed(:message) do |wp|
      allow(wp)
        .to receive(:project)
        .and_return(project)
    end
  end
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:representer) do
    described_class.create(message, current_user: user, embed_links: true)
  end
  let(:permissions) { all_permissions }
  let(:all_permissions) { %i(edit_messages) }

  subject { representer.to_json }

  before do
    allow(user)
      .to receive(:allowed_to?) do |permission, _project|
      permissions.include?(permission)
    end
  end

  describe '_links' do
    it_behaves_like 'has an untitled link' do
      let(:link) { 'self' }
      let(:href) { api_v3_paths.post message.id }
    end

    it_behaves_like 'has an untitled link' do
      let(:link) { :attachments }
      let(:href) { api_v3_paths.attachments_by_post message.id }
    end

    it_behaves_like 'has a titled link' do
      let(:link) { :project }
      let(:title) { project.name }
      let(:href) { api_v3_paths.project project.id }
    end

    it_behaves_like 'has an untitled action link' do
      let(:link) { :addAttachment }
      let(:href) { api_v3_paths.attachments_by_post message.id }
      let(:method) { :post }
      let(:permission) { :edit_messages }
    end
  end

  describe 'properties' do
    it_behaves_like 'property', :_type do
      let(:value) { 'Post' }
    end

    it_behaves_like 'property', :id do
      let(:value) { message.id }
    end

    it_behaves_like 'property', :subject do
      let(:value) { message.subject }
    end
  end

  describe '_embedded' do
    it 'has project embedded' do
      expect(subject)
        .to be_json_eql(project.name.to_json)
        .at_path('_embedded/project/name')
    end
  end
end
