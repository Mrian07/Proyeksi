#-- encoding: UTF-8


require_relative '../legacy_spec_helper'
require 'roles_controller'

describe RolesController, type: :controller do
  render_views

  fixtures :all

  before do
    User.current = nil
    session[:user_id] = 1 # admin
  end

  it 'should get index' do
    get :index
    assert_response :success
    assert_template 'index'

    refute_nil assigns(:roles)
    assert_equal Role.order(Arel.sql('builtin, position')).to_a, assigns(:roles)

    assert_select 'a',
                  attributes: { href: edit_role_path(1) },
                  content: 'Manager'
  end

  it 'should get new' do
    get :new
    assert_response :success
    assert_template 'new'
  end

  it 'should get edit' do
    get :edit, params: { id: 1 }
    assert_response :success
    assert_template 'edit'
    assert_equal Role.find(1), assigns(:role)
  end

  it 'should destroy' do
    r = Role.new(name: 'ToBeDestroyed', permissions: [:view_wiki_pages])
    assert r.save

    delete :destroy, params: { id: r }
    assert_redirected_to roles_path
    assert_nil Role.find_by(id: r.id)
  end

  it 'should destroy role in use' do
    delete :destroy, params: { id: 1 }
    assert_redirected_to roles_path
    assert flash[:error] == 'This role is in use and cannot be deleted.'
    refute_nil Role.find_by(id: 1)
  end

  it 'should get report' do
    get :report
    assert_response :success
    assert_template 'report'

    refute_nil assigns(:roles)
    assert_equal Role.order(Arel.sql('builtin, position')), assigns(:roles)

    assert_select 'input', attributes: { type: 'checkbox',
                                         name: 'permissions[3][]',
                                         value: 'add_work_packages',
                                         checked: 'checked' }

    assert_select 'input', attributes: { type: 'checkbox',
                                         name: 'permissions[3][]',
                                         value: 'delete_work_packages',
                                         checked: nil }
  end
end
