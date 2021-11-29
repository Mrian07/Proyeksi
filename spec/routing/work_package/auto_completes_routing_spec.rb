

require 'spec_helper'

describe WorkPackages::AutoCompletesController, type: :routing do
  it 'should connect GET /work_packages/auto_completes to work_package/auto_complete#index' do
    expect(get('/work_packages/auto_complete')).to route_to(controller: 'work_packages/auto_completes',
                                                            action: 'index')
  end

  it 'should connect PUT /work_packages/auto_completes to work_package/auto_complete#index' do
    expect(get('/work_packages/auto_complete')).to route_to(controller: 'work_packages/auto_completes',
                                                            action: 'index')
  end
end
