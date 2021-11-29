

require 'spec_helper'

describe 'preview', type: :routing do
  it 'should connect POST /meetings/:meeting_id/agenda/preview to meeting_agendas#preview' do
    expect(post('/meetings/1/agenda/preview')).to route_to(controller: 'meeting_agendas',
                                                           meeting_id: '1',
                                                           action: 'preview')
  end

  it 'should connect POST /meetings/:meeting_id/agenda/preview to meeting_minutes#preview' do
    expect(post('/meetings/1/minutes/preview')).to route_to(controller: 'meeting_minutes',
                                                            meeting_id: '1',
                                                            action: 'preview')
  end
end
