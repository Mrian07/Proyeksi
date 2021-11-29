#-- encoding: UTF-8


require_relative '../../legacy_spec_helper'

describe SortHelper, type: :helper do
  include SortHelper

  before do
    @session = nil
    @sort_param = nil
  end

  it 'should default_sort_clause_with_array' do
    sort_init 'attr1', 'desc'
    sort_update(['attr1', 'attr2'])

    assert_equal 'attr1 DESC', sort_clause
  end

  it 'should default_sort_clause_with_hash' do
    sort_init 'attr1', 'desc'
    sort_update('attr1' => 'table1.attr1', 'attr2' => 'table2.attr2')

    assert_equal 'table1.attr1 DESC', sort_clause
  end

  it 'should default_sort_clause_with_multiple_columns' do
    sort_init 'attr1', 'desc'
    sort_update('attr1' => ['table1.attr1', 'table1.attr2'], 'attr2' => 'table2.attr2')

    assert_equal 'table1.attr1 DESC, table1.attr2 DESC', sort_clause
  end

  it 'should params_sort' do
    @sort_param = 'attr1,attr2:desc'

    sort_init 'attr1', 'desc'
    sort_update('attr1' => 'table1.attr1', 'attr2' => 'table2.attr2')

    assert_equal 'table1.attr1, table2.attr2 DESC', sort_clause
    assert_equal 'attr1,attr2:desc', @session['foo_bar_sort']
  end

  it 'should invalid_params_sort' do
    @sort_param = 'invalid_key'

    sort_init 'attr1', 'desc'
    sort_update('attr1' => 'table1.attr1', 'attr2' => 'table2.attr2')

    assert_equal 'table1.attr1 DESC', sort_clause
    assert_equal 'attr1:desc', @session['foo_bar_sort']
  end

  it 'should invalid_order_params_sort' do
    @sort_param = 'attr1:foo:bar,attr2'

    sort_init 'attr1', 'desc'
    sort_update('attr1' => 'table1.attr1', 'attr2' => 'table2.attr2')

    assert_equal 'table1.attr1, table2.attr2', sort_clause
    assert_equal 'attr1,attr2', @session['foo_bar_sort']
  end

  private

  def controller_name; 'foo'; end

  def action_name; 'bar'; end

  def params; { sort: @sort_param }; end

  def session; @session ||= {}; end
end
