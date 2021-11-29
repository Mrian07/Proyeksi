

require 'spec_helper'

describe WorkPackagesController, type: :routing do
  it 'should connect GET /work_packages to work_packages#index' do
    expect(get('/work_packages')).to route_to(controller: 'work_packages',
                                              action: 'index')
  end

  it 'should connect GET /projects/blubs/work_packages to work_packages#index' do
    expect(get('/projects/blubs/work_packages')).to route_to(controller: 'work_packages',
                                                             project_id: 'blubs',
                                                             action: 'index')
  end

  it 'connects GET /work_packages/new to work_packages#index' do
    expect(get('/work_packages/new'))
      .to route_to(controller: 'work_packages',
                   action: 'index',
                   state: 'new')
  end

  it 'connects GET /projects/:project_id/work_packages/new to work_packages#index' do
    expect(get('/projects/1/work_packages/new'))
      .to route_to(controller: 'work_packages',
                   action: 'index',
                   project_id: '1',
                   state: 'new')
  end

  it 'should connect GET /work_packages/:id/overview to work_packages#show' do
    expect(get('/work_packages/1/overview'))
      .to route_to(controller: 'work_packages',
                   action: 'show', id: '1', state: 'overview')
  end

  it 'should connect GET /projects/:project_id/work_packages/:id/overview to work_packages#index' do
    expect(get('/projects/1/work_packages/2/overview'))
      .to route_to(controller: 'work_packages',
                   action: 'index',
                   project_id: '1',
                   state: '2/overview')
  end

  it 'should connect GET /work_packages/details/:state to work_packages#index' do
    expect(get('/work_packages/details/5/overview'))
      .to route_to(controller: 'work_packages',
                   action: 'index',
                   state: '5/overview')
  end

  it 'should connect GET /projects/:project_id/work_packages/details/:id/:state' +
     ' to work_packages#index' do
    expect(get('/projects/1/work_packages/details/2/overview'))
      .to route_to(controller: 'work_packages',
                   action: 'index',
                   project_id: '1',
                   state: 'details/2/overview')
  end

  it 'should connect GET /work_packages/:id to work_packages#show' do
    expect(get('/work_packages/1')).to route_to(controller: 'work_packages',
                                                action: 'show',
                                                id: '1')
  end

  it 'should connect GET /work_packages/:work_package_id/moves/new to work_packages/moves#new' do
    expect(get('/work_packages/1/move/new')).to route_to(controller: 'work_packages/moves',
                                                         action: 'new',
                                                         work_package_id: '1')
  end

  it 'should connect POST /work_packages/:work_package_id/moves to work_packages/moves#create' do
    expect(post('/work_packages/1/move/')).to route_to(controller: 'work_packages/moves',
                                                       action: 'create',
                                                       work_package_id: '1')
  end

  it 'should connect GET /work_packages/moves/new?ids=1,2,3 to work_packages/moves#new' do
    expect(get('/work_packages/move/new?ids=1,2,3')).to route_to(controller: 'work_packages/moves',
                                                                 action: 'new',
                                                                 ids: '1,2,3')
  end

  it 'should connect POST /work_packages/moves to work_packages/moves#create' do
    expect(post('/work_packages/move?ids=1,2,3')).to route_to(controller: 'work_packages/moves',
                                                              action: 'create',
                                                              ids: '1,2,3')
  end
end
