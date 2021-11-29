

require 'spec_helper'

describe ProjectsController, type: :routing do
  describe 'index' do
    it do
      expect(get('/projects')).to route_to(
        controller: 'projects', action: 'index'
      )
    end

    it do
      expect(get('/projects.atom')).to route_to(
        controller: 'projects', action: 'index', format: 'atom'
      )
    end

    it do
      expect(get('/projects.xml')).to route_to(
        controller: 'projects', action: 'index', format: 'xml'
      )
    end
  end

  describe 'new' do
    it do
      expect(get('/projects/new')).to route_to(
        controller: 'projects', action: 'new'
      )
    end
  end

  describe 'destroy_info' do
    it do
      expect(get('/projects/123/destroy_info')).to route_to(
        controller: 'projects', action: 'destroy_info', id: '123'
      )
    end
  end

  describe 'delete' do
    it do
      expect(delete('/projects/123')).to route_to(
        controller: 'projects', action: 'destroy', id: '123'
      )
    end

    it do
      expect(delete('/projects/123.xml')).to route_to(
        controller: 'projects', action: 'destroy', id: '123', format: 'xml'
      )
    end
  end

  describe 'templated' do
    it do
      expect(delete('/projects/123/templated'))
        .to route_to(controller: 'projects/templated', action: 'destroy', project_id: '123')
    end

    it do
      expect(post('/projects/123/templated'))
        .to route_to(controller: 'projects/templated', action: 'create', project_id: '123')
    end
  end

  describe 'miscellaneous' do
    it do
      expect(post('projects/123/archive')).to route_to(
        controller: 'projects/archive', action: 'create', project_id: '123'
      )
    end

    it do
      expect(delete('projects/123/archive')).to route_to(
        controller: 'projects/archive', action: 'destroy', project_id: '123'
      )
    end

    it do
      expect(get('projects/123/copy')).to route_to(
        controller: 'projects', action: 'copy', id: '123'
      )
    end
  end

  describe 'types' do
    it do
      expect(patch('/projects/123/types')).to route_to(
        controller: 'projects', action: 'types', id: '123'
      )
    end
  end

  describe 'level_list' do
    it do
      expect(get('/projects/level_list.json')).to route_to(
        controller: 'projects', action: 'level_list', format: 'json'
      )
    end
  end
end
