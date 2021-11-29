#-- encoding: UTF-8



require_relative '../legacy_spec_helper'

describe Wiki, type: :model do
  fixtures :all

  it 'should create' do
    wiki = Wiki.new(project: Project.find(2))
    assert !wiki.save
    assert_equal 1, wiki.errors.count

    wiki.start_page = 'Start page'
    assert wiki.save
  end

  it 'should update' do
    @wiki = Wiki.find(1)
    @wiki.start_page = 'Another start page'
    assert @wiki.save
    @wiki.reload
    assert_equal 'Another start page', @wiki.start_page
  end

  it 'should find page' do
    wiki = Wiki.find(1)
    page = WikiPage.find(2)

    assert_equal page, wiki.find_page('Another page')
    assert_equal page, wiki.find_page('ANOTHER page')

    page = WikiPage.find(10)
    assert_equal page, wiki.find_page('Этика менеджмента')

    page = FactoryBot.create(:wiki_page, wiki: wiki, title: '2009\\02\\09')
    assert_equal page, wiki.find_page('2009\\02\\09')
  end
end
