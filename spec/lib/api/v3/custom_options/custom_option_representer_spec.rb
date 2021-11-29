

require 'spec_helper'

describe ::API::V3::CustomOptions::CustomOptionRepresenter do
  include ::API::V3::Utilities::PathHelper

  let(:custom_option) { FactoryBot.build_stubbed(:custom_option, custom_field: custom_field) }
  let(:custom_field) { FactoryBot.build_stubbed(:list_wp_custom_field) }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:representer) do
    described_class.new(custom_option, current_user: user)
  end

  subject { representer.to_json }

  describe 'generation' do
    describe '_links' do
      it_behaves_like 'has a titled link' do
        let(:link) { 'self' }
        let(:href) { api_v3_paths.custom_option custom_option.id }
        let(:title) { custom_option.to_s }
      end
    end

    it 'has the type "CustomOption"' do
      is_expected.to be_json_eql('CustomOption'.to_json).at_path('_type')
    end

    it 'has an id' do
      is_expected.to be_json_eql(custom_option.id.to_json).at_path('id')
    end

    it 'has a value' do
      is_expected.to be_json_eql(custom_option.to_s.to_json).at_path('value')
    end
  end
end
