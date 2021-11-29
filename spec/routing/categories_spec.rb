

require 'spec_helper'

describe CategoriesController, type: :routing do
  it 'should connect GET /projects/test/categories/new to categories#new' do
    expect(get('/projects/test/categories/new')).to route_to(controller: 'categories',
                                                             action: 'new',
                                                             project_id: 'test')
  end

  it 'should connect POST /projects/test/categories to categories#create' do
    expect(post('/projects/test/categories')).to route_to(controller: 'categories',
                                                          action: 'create',
                                                          project_id: 'test')
  end

  it 'should connect GET /categories/5/edit to categories#edit' do
    expect(get('/categories/5/edit')).to route_to(controller: 'categories',
                                                  action: 'edit',
                                                  id: '5')
  end

  it 'should connect PUT /categories/5 to categories#update' do
    expect(put('/categories/5')).to route_to(controller: 'categories',
                                             action: 'update',
                                             id: '5')
  end

  it 'should connect DELETE /categories/5 to categories#delete' do
    expect(delete('/categories/5')).to route_to(controller: 'categories',
                                                action: 'destroy',
                                                id: '5')
  end
end
