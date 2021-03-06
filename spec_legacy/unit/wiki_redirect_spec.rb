#-- encoding: UTF-8


require_relative '../legacy_spec_helper'

describe WikiRedirect, type: :model do
  fixtures :all

  before do
    @wiki = Wiki.find(1)
    @original = WikiPage.create(wiki: @wiki, title: 'Original title')
  end

  it 'should create redirect' do
    @original.title = 'New title'
    assert @original.save
    @original.reload

    assert_equal 'New title', @original.title
    assert @wiki.redirects.find_by(title: 'original-title')
    assert @wiki.find_page('Original title')
    assert @wiki.find_page('ORIGINAL title')
  end

  it 'should update redirect' do
    # create a redirect that point to this page
    assert WikiRedirect.create(wiki: @wiki, title: 'An old page', redirects_to: @original.slug)

    @original.title = 'New title'
    @original.save
    # make sure the old page now points to the new page
    assert_equal 'New title', @wiki.find_page('An old page').title
  end

  it 'should reverse rename' do
    # create a redirect that point to this page
    assert WikiRedirect.create(wiki: @wiki, title: 'An old page', redirects_to: @original.slug)

    @original.title = 'An old page'
    @original.save
    assert !@wiki.redirects.find_by(title: 'an-old-page', redirects_to: 'an-old-page')
    assert @wiki.redirects.find_by(title: 'original-title', redirects_to: 'an-old-page')
  end

  it 'should rename to already redirected' do
    assert WikiRedirect.create(wiki: @wiki, title: 'an-old-page', redirects_to: 'other-page')

    @original.title = 'An old page'
    @original.save
    # this redirect have to be removed since 'An old page' page now exists
    assert !@wiki.redirects.find_by(title: 'an-old-page', redirects_to: 'other-page')
  end

  it 'should redirects removed when deleting page' do
    assert WikiRedirect.create(wiki: @wiki, title: 'an-old-page', redirects_to: @original.slug)

    @original.destroy
    assert !@wiki.redirects.first
  end
end
