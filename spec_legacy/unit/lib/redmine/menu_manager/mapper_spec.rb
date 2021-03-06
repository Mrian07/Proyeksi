#-- encoding: UTF-8


require_relative '../../../../legacy_spec_helper'

describe Redmine::MenuManager::Mapper do
  it 'should push onto root' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_overview, { controller: 'projects', action: 'show' }, {}

    menu_mapper.exists?(:test_overview)
  end

  it 'should push onto parent' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_overview, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_child, { controller: 'projects', action: 'show' }, parent: :test_overview

    assert menu_mapper.exists?(:test_child)
    assert_equal :test_child, menu_mapper.find(:test_child).name
  end

  it 'should push onto grandparent' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_overview, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_child, { controller: 'projects', action: 'show' }, parent: :test_overview
    menu_mapper.push :test_grandchild, { controller: 'projects', action: 'show' }, parent: :test_child

    assert menu_mapper.exists?(:test_grandchild)
    grandchild = menu_mapper.find(:test_grandchild)
    assert_equal :test_grandchild, grandchild.name
    assert_equal :test_child, grandchild.parent.name
  end

  it 'should push first' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_second, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_third, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_fourth, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_fifth, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_first, { controller: 'projects', action: 'show' }, first: true

    root = menu_mapper.find(:root)
    assert_equal 5, root.children.size
    { 0 => :test_first, 1 => :test_second, 2 => :test_third, 3 => :test_fourth, 4 => :test_fifth }.each do |position, name|
      refute_nil root.children[position]
      assert_equal name, root.children[position].name
    end
  end

  it 'should push before' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_first, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_second, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_fourth, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_fifth, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_third, { controller: 'projects', action: 'show' }, before: :test_fourth

    root = menu_mapper.find(:root)
    assert_equal 5, root.children.size
    { 0 => :test_first, 1 => :test_second, 2 => :test_third, 3 => :test_fourth, 4 => :test_fifth }.each do |position, name|
      refute_nil root.children[position]
      assert_equal name, root.children[position].name
    end
  end

  it 'should push after' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_first, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_second, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_third, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_fifth, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_fourth, { controller: 'projects', action: 'show' }, after: :test_third

    root = menu_mapper.find(:root)
    assert_equal 5, root.children.size
    { 0 => :test_first, 1 => :test_second, 2 => :test_third, 3 => :test_fourth, 4 => :test_fifth }.each do |position, name|
      refute_nil root.children[position]
      assert_equal name, root.children[position].name
    end
  end

  it 'should push last' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_first, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_second, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_third, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_fifth, { controller: 'projects', action: 'show' }, last: true
    menu_mapper.push :test_fourth, { controller: 'projects', action: 'show' }, {}

    root = menu_mapper.find(:root)
    assert_equal 5, root.children.size
    { 0 => :test_first, 1 => :test_second, 2 => :test_third, 3 => :test_fourth, 4 => :test_fifth }.each do |position, name|
      refute_nil root.children[position]
      assert_equal name, root.children[position].name
    end
  end

  it 'should exists for child node' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_overview, { controller: 'projects', action: 'show' }, {}
    menu_mapper.push :test_child, { controller: 'projects', action: 'show' }, parent: :test_overview

    assert menu_mapper.exists?(:test_child)
  end

  it 'should exists for invalid node' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_overview, { controller: 'projects', action: 'show' }, {}

    assert !menu_mapper.exists?(:nothing)
  end

  it 'should find' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_overview, { controller: 'projects', action: 'show' }, {}

    item = menu_mapper.find(:test_overview)
    assert_equal :test_overview, item.name
    assert_equal({ controller: 'projects', action: 'show' }, item.url)
  end

  it 'should find missing' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_overview, { controller: 'projects', action: 'show' }, {}

    item = menu_mapper.find(:nothing)
    assert_equal nil, item
  end

  it 'should delete' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    menu_mapper.push :test_overview, { controller: 'projects', action: 'show' }, {}
    refute_nil menu_mapper.delete(:test_overview)

    assert_nil menu_mapper.find(:test_overview)
  end

  it 'should delete missing' do
    menu_mapper = Redmine::MenuManager::Mapper.new(:test_menu, {})
    assert_nil menu_mapper.delete(:test_missing)
  end

  specify 'deleting all items' do
    # Exposed by deleting :last items
    Redmine::MenuManager.map :test_menu do |menu|
      menu.push :not_last, ProyeksiApp::Static::Links.help_link
      menu.push :administration, { controller: 'projects', action: 'show' }, last: true
      menu.push :help, ProyeksiApp::Static::Links.help_link, last: true
    end

    expect do
      Redmine::MenuManager.map :test_menu do |menu|
        menu.delete(:administration)
        menu.delete(:help)
        menu.push :test_overview, { controller: 'projects', action: 'show' }, {}
      end
    end.not_to raise_error
  end
end
