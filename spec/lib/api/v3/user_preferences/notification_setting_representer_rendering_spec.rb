

require 'spec_helper'

describe ::API::V3::UserPreferences::NotificationSettingRepresenter, 'rendering' do
  include ::API::V3::Utilities::PathHelper

  subject(:generated) { representer.to_json }

  let(:project) { FactoryBot.build_stubbed :project }
  let(:notification_setting) { FactoryBot.build_stubbed(:notification_setting, project: project) }

  let(:representer) do
    described_class.create notification_setting,
                           current_user: current_user,
                           embed_links: embed_links
  end

  let(:embed_links) { true }

  current_user { FactoryBot.build_stubbed(:user) }

  describe '_links' do
    describe 'self' do
      # No self link as the representer is rendered as part of the user preferences.
      it_behaves_like 'has no link' do
        let(:link) { 'self' }
      end
    end

    describe 'project' do
      it_behaves_like 'has a titled link' do
        let(:link) { 'project' }
        let(:href) { api_v3_paths.project(project.id) }
        let(:title) { project.name }
      end
    end
  end

  describe 'properties' do
    it 'has no _type' do
      expect(generated)
        .not_to have_json_path('_type')
    end

    NotificationSetting.all_settings.each do |property|
      it_behaves_like 'property', property.to_s.camelize(:lower) do
        let(:value) { notification_setting.send property }
      end
    end
  end

  describe '_embedded' do
    describe 'project' do
      it 'skips embedding the project' do
        expect(generated)
          .not_to have_json_path('_embedded/project')
      end
    end
  end
end
