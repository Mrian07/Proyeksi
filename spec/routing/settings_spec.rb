

require 'spec_helper'

describe 'settings routes', type: :routing do
  it do
    expect(get('/admin/settings/plugin/abc'))
      .to route_to(controller: 'admin/settings',
                   action: 'show_plugin',
                   id: 'abc')
  end

  it do
    expect(post('/admin/settings/plugin/abc'))
      .to route_to(controller: 'admin/settings',
                   action: 'update_plugin',
                   id: 'abc')
  end
end
