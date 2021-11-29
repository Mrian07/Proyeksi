

require 'spec_helper'

describe 'admin mail_notifications routes', type: :routing do
  it do
    expect(get('admin/settings/mail_notifications'))
      .to route_to('admin/settings/mail_notifications_settings#show')
  end

  it do
    expect(patch('admin/settings/mail_notifications'))
      .to route_to('admin/settings/mail_notifications_settings#update')
  end
end
