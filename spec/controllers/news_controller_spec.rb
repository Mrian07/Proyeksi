

require 'spec_helper'

describe NewsController, type: :controller do
  render_views

  include BecomeMember

  let(:user) do
    FactoryBot.create(:admin)
  end
  let(:project) { FactoryBot.create(:project) }
  let(:news) { FactoryBot.create(:news) }

  before do
    allow(User).to receive(:current).and_return user
  end

  describe '#index' do
    it 'renders index' do
      get :index

      expect(response).to be_successful
      expect(response).to render_template 'index'

      expect(assigns(:project)).to be_nil
      expect(assigns(:newss)).not_to be_nil
    end

    it 'renders index with project' do
      get :index, params: { project_id: project.id }

      expect(response).to be_successful
      expect(response).to render_template 'index'
      expect(assigns(:newss)).not_to be_nil
    end
  end

  describe '#show' do
    it 'renders show' do
      get :show, params: { id: news.id }

      expect(response).to be_successful
      expect(response).to render_template 'show'

      expect(response.body).to have_selector('h2', text: news.title)
    end

    it 'renders show with slug' do
      get :show, params: { id: "#{news.id}-some-news-title" }

      expect(response).to be_successful
      expect(response).to render_template 'show'

      expect(response.body).to have_selector('h2', text: news.title)
    end

    it 'renders error if news item is not found' do
      get :show, params: { id: -1 }

      expect(response).to be_not_found
    end
  end

  describe '#new' do
    it 'renders new' do
      get :new, params: { project_id: project.id }

      expect(response).to be_successful
      expect(response).to render_template 'new'
    end
  end

  describe '#create' do
    context 'with news_added notifications' do
      it 'persists a news item' do
        become_member_with_permissions(project, user)

        post :create,
             params: {
               project_id: project.id,
               news: {
                 title: 'NewsControllerTest',
                 description: 'This is the description',
                 summary: ''
               }
             }
        expect(response).to redirect_to project_news_index_path(project)

        news = News.find_by!(title: 'NewsControllerTest')
        expect(news).not_to be_nil
        expect(news.description).to eq 'This is the description'
        expect(news.author).to eq user
        expect(news.project).to eq project
      end
    end

    it "doesn't persist if validations fail" do
      post :create,
           params: {
             project_id: project.id,
             news: {
               title: '',
               description: 'This is the description',
               summary: ''
             }
           }

      expect(response).to be_successful
      expect(response).to render_template 'new'
      expect(assigns(:news)).not_to be_nil
      expect(assigns(:news)).to be_new_record

      expect(response.body).to have_selector('div.op-toast.-error', text: /1 error/)
    end
  end

  describe '#edit' do
    it 'renders edit' do
      get :edit, params: { id: news.id }
      expect(response).to be_successful
      expect(response).to render_template 'edit'
    end
  end

  describe '#update' do
    it 'updates the news element' do
      put :update,
          params: { id: news.id, news: { description: 'Description changed by test_post_edit' } }

      expect(response).to redirect_to news_path(news)

      news.reload
      expect(news.description).to eq 'Description changed by test_post_edit'
    end
  end

  describe '#destroy' do
    it 'deletes the news element and redirects to the news overview page' do
      delete :destroy, params: { id: news.id }

      expect(response).to redirect_to project_news_index_path(news.project)
      expect { news.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
