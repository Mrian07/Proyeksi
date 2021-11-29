

require 'spec_helper'

describe 'my routes', type: :routing do
  it '/my/account GET routes to my#account' do
    expect(get('/my/account')).to route_to('my#account')
  end

  it '/my/account PATCH routes to my#update_account' do
    expect(patch('/my/account')).to route_to('my#update_account')
  end

  it '/my/settings GET routes to my#settings' do
    expect(get('/my/settings')).to route_to('my#settings')
  end

  it '/my/settings PATCH routes to my#update_account' do
    expect(patch('/my/settings')).to route_to('my#update_settings')
  end

  it '/my/notifications GET routes to my#notifications' do
    expect(get('/my/notifications')).to route_to('my#notifications')
  end

  it '/my/reminders GET routes to my#notifications' do
    expect(get('/my/reminders')).to route_to('my#reminders')
  end

  it '/my/generate_rss_key POST routes to my#generate_rss_key' do
    expect(post('/my/generate_rss_key')).to route_to('my#generate_rss_key')
  end

  it '/my/generate_api_key POST routes to my#generate_api_key' do
    expect(post('/my/generate_api_key')).to route_to('my#generate_api_key')
  end

  it '/my/deletion_info GET routes to users#deletion_info' do
    expect(get('/my/deletion_info')).to route_to(controller: 'users',
                                                 action: 'deletion_info')
  end
end
