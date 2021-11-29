

require 'spec_helper'

describe 'admin routes', type: :routing do
  it 'connects GET /admin to admin#index' do
    expect(get('/admin'))
      .to route_to('admin#index')
  end

  it 'connects GET /projects to projects#index' do
    expect(get('/projects'))
      .to route_to('projects#index')
  end

  it 'connects GET /admin/plugins to admin#plugins' do
    expect(get('/admin/plugins'))
      .to route_to('admin#plugins')
  end

  it 'connects GET /admin/info to admin#info' do
    expect(get('/admin/info'))
      .to route_to('admin#info')
  end

  it 'connects POST /admin/force_user_language to admin#force_user_language' do
    expect(post('/admin/force_user_language'))
      .to route_to('admin#force_user_language')
  end

  it 'connects POST /admin/test_email to admin#test_email' do
    expect(post('/admin/test_email'))
      .to route_to('admin#test_email')
  end
end
