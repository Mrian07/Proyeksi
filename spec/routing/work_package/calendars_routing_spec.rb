

require 'spec_helper'

describe WorkPackages::CalendarsController, type: :routing do
  it 'should connect GET /work_packages/calendar to work_package/calendar#index' do
    expect(get('/work_packages/calendar')).to route_to(controller: 'work_packages/calendars',
                                                       action: 'index')
  end

  it 'should connect GET /project/1/work_packages/calendar to work_package/calendar#index' do
    expect(get('/projects/1/work_packages/calendar')).to route_to(controller: 'work_packages/calendars',
                                                                  action: 'index',
                                                                  project_id: '1')
  end
end
