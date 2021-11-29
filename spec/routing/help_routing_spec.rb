

require 'spec_helper'

describe HelpController, type: :routing do
  it 'connects GET /help/keyboard_shortcuts to help#keyboard_shortcuts' do
    expect(get('/help/keyboard_shortcuts'))
      .to route_to(controller: 'help',
                   action: 'keyboard_shortcuts')
  end
end
