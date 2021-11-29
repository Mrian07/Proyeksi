

require 'spec_helper'

describe AttributeHelpTextsController, type: :routing do
  it 'should route CRUD to the controller' do
    expect(get('/admin/attribute_help_texts'))
      .to route_to(controller: 'attribute_help_texts', action: 'index')

    expect(get('/admin/attribute_help_texts/1/edit'))
      .to route_to(controller: 'attribute_help_texts', action: 'edit', id: '1')

    expect(post('/admin/attribute_help_texts'))
      .to route_to(controller: 'attribute_help_texts', action: 'create')

    expect(put('/admin/attribute_help_texts/1'))
      .to route_to(controller: 'attribute_help_texts', action: 'update', id: '1')

    expect(delete('/admin/attribute_help_texts/1'))
      .to route_to(controller: 'attribute_help_texts', action: 'destroy', id: '1')
  end
end
