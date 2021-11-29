

require 'spec_helper'

describe ::API::V3::CustomActions::CustomActionRepresenter do
  include ::API::V3::Utilities::PathHelper

  let(:custom_action) { FactoryBot.build_stubbed(:custom_action) }
  let(:user) { FactoryBot.build_stubbed(:user) }

  let(:representer) do
    described_class.new(custom_action, current_user: user, embed_links: true)
  end

  subject { representer.to_json }

  context 'properties' do
    it 'has a _type property' do
      is_expected
        .to be_json_eql('CustomAction'.to_json)
        .at_path('_type')
    end

    it 'has a name property' do
      is_expected
        .to be_json_eql(custom_action.name.to_json)
        .at_path('name')
    end

    it 'has a description property' do
      is_expected
        .to be_json_eql(custom_action.description.to_json)
        .at_path('description')
    end
  end

  context 'links' do
    it_behaves_like 'has a titled link' do
      let(:link) { 'self' }
      let(:href) { api_v3_paths.custom_action(custom_action.id) }
      let(:title) { custom_action.name }
    end

    it_behaves_like 'has a titled link' do
      let(:link) { 'executeImmediately' }
      let(:href) { api_v3_paths.custom_action_execute(custom_action.id) }
      let(:title) { "Execute #{custom_action.name}" }
      let(:method) { 'post' }
    end
  end
end
