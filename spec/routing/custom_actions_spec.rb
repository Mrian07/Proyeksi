

require 'spec_helper'

describe 'custom_actions routes', type: :routing do
  describe 'index' do
    it 'links GET /admin/custom_actions' do
      expect(get('/admin/custom_actions'))
        .to route_to('custom_actions#index')
    end
  end

  describe 'new' do
    it 'links GET /admin/custom_actions/new' do
      expect(get('/admin/custom_actions/new'))
        .to route_to('custom_actions#new')
    end
  end

  describe 'create' do
    it 'links POST /admin/custom_actions' do
      expect(post('/admin/custom_actions'))
        .to route_to('custom_actions#create')
    end
  end

  describe 'edit' do
    it 'links GET /admin/custom_actions/:id/edit' do
      expect(get('/admin/custom_actions/42/edit'))
        .to route_to('custom_actions#edit', id: "42")
    end
  end

  describe 'update' do
    it 'links PATCH /admin/custom_actions/:id' do
      expect(patch('/admin/custom_actions/42'))
        .to route_to('custom_actions#update', id: "42")
    end
  end

  describe 'delete' do
    it 'links DELETE /admin/custom_actions/:id' do
      expect(delete('/admin/custom_actions/42'))
        .to route_to('custom_actions#destroy', id: "42")
    end
  end
end
