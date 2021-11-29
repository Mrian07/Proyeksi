

require 'spec_helper'

describe WorkPackagesController, type: :routing do
  it 'should connect GET /project/1/work_packages/report to work_package/report#report' do
    expect(get('/projects/1/work_packages/report')).to route_to(controller: 'work_packages/reports',
                                                                action: 'report',
                                                                project_id: '1')
  end

  it 'should connect GET /project/1/work_packages/report/assigned_to to work_package/report#report_details' do
    expect(get('/projects/1/work_packages/report/assigned_to')).to route_to(controller: 'work_packages/reports',
                                                                            action: 'report_details',
                                                                            project_id: '1',
                                                                            detail: 'assigned_to')
  end
end
