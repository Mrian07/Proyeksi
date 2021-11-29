

require 'spec_helper'

describe 'account routes', type: :routing do
  it '/account/lost_password GET routes to account#lost_password' do
    expect(get('/account/lost_password')).to route_to('account#lost_password')
  end

  it '/account/lost_password POST routes to account#lost_password' do
    expect(post('/account/lost_password')).to route_to('account#lost_password')
  end

  it '/accounts/register GET routes to account#register' do
    expect(get('/account/register')).to route_to('account#register')
  end

  it '/accounts/register POST routes to account#register' do
    expect(post('/account/register')).to route_to('account#register')
  end
end
