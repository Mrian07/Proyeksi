#-- encoding: UTF-8


require_relative '../legacy_spec_helper'
require 'workflows_controller'

describe WorkflowsController, type: :controller do
  render_views

  fixtures :all

  before do
    User.current = nil
    session[:user_id] = 1 # admin
  end

  it 'should get edit' do
    get :edit
    assert_response :success
    assert_template 'edit'
    refute_nil assigns(:roles)
    refute_nil assigns(:types)
  end

  it 'should get edit with role and type' do
    Workflow.delete_all
    Workflow.create!(role_id: 1, type_id: 1, old_status_id: 2, new_status_id: 3)
    Workflow.create!(role_id: 2, type_id: 1, old_status_id: 3, new_status_id: 5)

    get :edit, params: { role_id: 2, type_id: 1 }
    assert_response :success
    assert_template 'edit'

    # used status only
    refute_nil assigns(:statuses)
    assert_equal [2, 3, 5], assigns(:statuses).map(&:id)

    # allowed transitions
    assert_select 'input', attributes: { type: 'checkbox',
                                         name: 'status[3][5][]',
                                         value: 'always',
                                         checked: 'checked' }
    # not allowed
    assert_select 'input', attributes: { type: 'checkbox',
                                         name: 'status[3][2][]',
                                         value: 'always',
                                         checked: nil }
    # unused
    assert_select('input', { attributes: { type: 'checkbox',
                                           name: 'status[1][1][]' } }, false)
  end

  it 'should get edit with role and type and all statuses' do
    Workflow.delete_all

    get :edit, params: { role_id: 2, type_id: 1, used_statuses_only: '0' }
    assert_response :success
    assert_template 'edit'

    refute_nil assigns(:statuses)
    assert_equal Status.count, assigns(:statuses).size

    assert_select 'input', attributes: { type: 'checkbox',
                                         name: 'status[1][1][]',
                                         value: 'always',
                                         checked: nil }
  end

  it 'should get copy' do
    get :copy
    assert_response :success
    assert_template 'copy'
  end

  it 'should post copy one to one' do
    source_transitions = status_transitions(type_id: 1, role_id: 2)

    post :copy, params: { source_type_id: '1', source_role_id: '2',
                          target_type_ids: ['3'], target_role_ids: ['1'] }
    assert_response 302
    assert_equal source_transitions, status_transitions(type_id: 3, role_id: 1)
  end

  it 'should post copy one to many' do
    source_transitions = status_transitions(type_id: 1, role_id: 2)

    post :copy, params: { source_type_id: '1', source_role_id: '2',
                          target_type_ids: ['2', '3'], target_role_ids: ['1', '3'] }
    assert_response 302
    assert_equal source_transitions, status_transitions(type_id: 2, role_id: 1)
    assert_equal source_transitions, status_transitions(type_id: 3, role_id: 1)
    assert_equal source_transitions, status_transitions(type_id: 2, role_id: 3)
    assert_equal source_transitions, status_transitions(type_id: 3, role_id: 3)
  end

  it 'should post copy many to many' do
    source_t2 = status_transitions(type_id: 2, role_id: 2)
    source_t3 = status_transitions(type_id: 3, role_id: 2)

    post :copy, params: { source_type_id: 'any', source_role_id: '2',
                          target_type_ids: ['2', '3'], target_role_ids: ['1', '3'] }
    assert_response 302
    assert_equal source_t2, status_transitions(type_id: 2, role_id: 1)
    assert_equal source_t3, status_transitions(type_id: 3, role_id: 1)
    assert_equal source_t2, status_transitions(type_id: 2, role_id: 3)
    assert_equal source_t3, status_transitions(type_id: 3, role_id: 3)
  end

  # Returns an array of status transitions that can be compared
  def status_transitions(conditions)
    Workflow
      .where(conditions)
      .order(Arel.sql('type_id, role_id, old_status_id, new_status_id'))
      .map { |w| [w.old_status, w.new_status_id] }
  end
end
