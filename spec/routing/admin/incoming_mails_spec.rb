

require 'spec_helper'

describe 'admin incoming_mails routes', type: :routing do
  it do
    expect(get('admin/settings/incoming_mails'))
      .to route_to('admin/settings/incoming_mails_settings#show')
  end

  it do
    expect(patch('admin/settings/incoming_mails'))
      .to route_to('admin/settings/incoming_mails_settings#update')
  end
end
