

require 'spec_helper'

describe News::CommentsController, type: :controller do
  render_views

  let(:user) { FactoryBot.create(:admin)   }
  let(:news) { FactoryBot.create(:news)    }

  before do
    allow(User).to receive(:current).and_return user
  end

  describe '#create' do
    it 'assigns a comment to the news item and redirects to the news page' do
      post :create, params: { news_id: news.id, comment: { comments: 'This is a test comment' } }

      expect(response).to redirect_to news_path(news)

      latest_comment = news.comments.reorder(created_at: :desc).first
      expect(latest_comment).not_to be_nil
      expect(latest_comment.comments).to eq 'This is a test comment'
      expect(latest_comment.author).to eq user
    end

    it "doesn't create a comment when it is invalid" do
      expect do
        post :create, params: { news_id: news.id, comment: { comments: '' } }
        expect(response).to redirect_to news_path(news)
      end.not_to change { Comment.count }
    end
  end

  describe '#destroy' do
    it 'deletes the comment and redirects to the news page' do
      comment = FactoryBot.create :comment, commented: news

      expect do
        delete :destroy, params: { id: comment.id }
      end.to change { Comment.count }.by -1

      expect(response).to redirect_to news_path(news)
      expect { comment.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
