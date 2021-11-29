

require 'spec_helper'

describe WorkPackages::BulkController, type: :routing do
  it 'should connect GET /work_packages/bulk/edit to work_package_bulk/edit' do
    expect(get('/work_packages/bulk/edit')).to route_to(controller: 'work_packages/bulk',
                                                        action: 'edit')
  end

  it 'should connect PUT /work_packages/bulk/update to work_package_bulk#update' do
    expect(put('/work_packages/bulk')).to route_to(controller: 'work_packages/bulk',
                                                   action: 'update')
  end

  it 'should connect DELETE /work_packages/bulk to work_package_bulk#destroy' do
    expect(delete('/work_packages/bulk')).to route_to(controller: 'work_packages/bulk',
                                                      action: 'destroy')
  end
end
