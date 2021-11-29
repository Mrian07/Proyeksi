

require 'spec_helper'

describe Projects::SettingsController, type: :routing do
  describe 'show' do
    it do
      expect(get('/projects/123/settings/general'))
        .to route_to(
          controller: 'projects/settings/general', action: 'show', project_id: '123'
        )
    end

    it do
      expect(get('/projects/123/settings/modules'))
        .to route_to(
          controller: 'projects/settings/modules', action: 'show', project_id: '123'
        )
    end

    it do
      expect(patch('/projects/123/settings/modules'))
        .to route_to(
          controller: 'projects/settings/modules', action: 'update', project_id: '123'
        )
    end

    it do
      expect(get('/projects/123/settings/custom_fields'))
        .to route_to(
          controller: 'projects/settings/custom_fields', action: 'show', project_id: '123'
        )
    end

    it do
      expect(patch('/projects/123/settings/custom_fields'))
        .to route_to(
          controller: 'projects/settings/custom_fields', action: 'update', project_id: '123'
        )
    end

    it do
      expect(get('/projects/123/settings/versions'))
        .to route_to(
          controller: 'projects/settings/versions', action: 'show', project_id: '123'
        )
    end

    it do
      expect(get('/projects/123/settings/categories'))
        .to route_to(
          controller: 'projects/settings/categories', action: 'show', project_id: '123'
        )
    end

    it do
      expect(get('/projects/123/settings/repository'))
        .to route_to(
          controller: 'projects/settings/repository', action: 'show', project_id: '123'
        )
    end

    it do
      expect(get('/projects/123/settings/time_entry_activities'))
        .to route_to(
          controller: 'projects/settings/time_entry_activities', action: 'show', project_id: '123'
        )
    end

    it do
      expect(get('/projects/123/settings/types'))
        .to route_to(
          controller: 'projects/settings/types', action: 'show', project_id: '123'
        )
    end

    it do
      expect(patch('/projects/123/settings/types'))
        .to route_to(
          controller: 'projects/settings/types', action: 'update', project_id: '123'
        )
    end
  end
end
