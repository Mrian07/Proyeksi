

require 'spec_helper'

describe ::API::V3::WikiPages::WikiPageRepresenter, 'rendering' do
  include ::API::V3::Utilities::PathHelper

  let(:wiki_page) do
    FactoryBot.build_stubbed(:wiki_page) do |wp|
      allow(wp)
        .to receive(:project)
        .and_return(project)
    end
  end
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:representer) do
    described_class.create(wiki_page, current_user: user, embed_links: true)
  end
  let(:permissions) { all_permissions }
  let(:all_permissions) { %i(edit_wiki_pages) }

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
      let(:href) { api_v3_paths.wiki_page wiki_page.id }
    end

    it_behaves_like 'has an untitled link' do
      let(:link) { :attachments }
      let(:href) { api_v3_paths.attachments_by_wiki_page wiki_page.id }
    end

    it_behaves_like 'has a titled link' do
      let(:link) { :project }
      let(:title) { project.name }
      let(:href) { api_v3_paths.project project.id }
    end

    it_behaves_like 'has an untitled action link' do
      let(:link) { :addAttachment }
      let(:href) { api_v3_paths.attachments_by_wiki_page wiki_page.id }
      let(:method) { :post }
      let(:permission) { :edit_wiki_pages }
    end
  end

  describe 'properties' do
    it_behaves_like 'property', :_type do
      let(:value) { 'WikiPage' }
    end

    it_behaves_like 'property', :id do
      let(:value) { wiki_page.id }
    end

    it_behaves_like 'property', :title do
      let(:value) { wiki_page.title }
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
