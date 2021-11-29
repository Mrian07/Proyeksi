#-- encoding: UTF-8


require_relative './../legacy_spec_helper'

describe Comment, type: :model do
  include MiniTest::Assertions # refute

  it 'should validations' do
    # factory valid
    assert FactoryBot.build(:comment).valid?

    # comment text required
    refute FactoryBot.build(:comment, comments: '').valid?
    # object that is commented required
    refute FactoryBot.build(:comment, commented: nil).valid?
    # author required
    refute FactoryBot.build(:comment, author: nil).valid?
  end

  it 'should create' do
    user = FactoryBot.create(:user)
    news = FactoryBot.create(:news)
    comment = Comment.new(commented: news, author: user, comments: 'some important words')
    assert comment.save
    assert_equal 1, news.reload.comments_count
  end

  it 'should create through news' do
    user = FactoryBot.create(:user)
    news = FactoryBot.create(:news)
    comment = news.new_comment(author: user, comments: 'some important words')
    assert comment.save
    assert_equal 1, news.reload.comments_count
  end

  it 'should create comment through news' do
    user = FactoryBot.create(:user)
    news = FactoryBot.create(:news)
    news.post_comment!(author: user, comments: 'some important words')
    assert_equal 1, news.reload.comments_count
  end

  it 'should text' do
    comment = FactoryBot.build(:comment, comments: 'something useful')
    assert_equal 'something useful', comment.text
  end

  # TODO: testing #destroy really needed?
  it 'should destroy' do
    # just setup
    news = FactoryBot.create(:news)
    comment = FactoryBot.build(:comment)
    news.comments << comment
    assert comment.persisted?

    # #reload is needed to refresh the count
    assert_equal 1, news.reload.comments_count
    comment.destroy
    assert_equal 0, news.reload.comments_count
  end
end
