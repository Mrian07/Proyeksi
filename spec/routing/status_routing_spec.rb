

require 'spec_helper'

describe StatusesController, type: :routing do
  describe 'index' do
    it { expect(get('/statuses')).to route_to(controller: 'statuses', action: 'index') }
  end

  describe 'new' do
    it { expect(get('/statuses/new')).to route_to(controller: 'statuses', action: 'new') }
  end

  describe 'create' do
    it { expect(post('/statuses')).to route_to(controller: 'statuses', action: 'create') }
  end

  describe 'update' do
    it { expect(put('/statuses/123')).to route_to(controller: 'statuses', action: 'update', id: '123') }
  end

  describe 'delete' do
    it { expect(delete('/statuses/123')).to route_to(controller: 'statuses', action: 'destroy', id: '123') }
  end

  describe 'update_work_package_done_ratio' do
    it do
      expect(post('/statuses/update_work_package_done_ratio')).to route_to(
        controller: 'statuses',
        action: 'update_work_package_done_ratio'
      )
    end
  end
end
