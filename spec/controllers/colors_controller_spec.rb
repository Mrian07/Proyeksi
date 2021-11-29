

require 'spec_helper'

describe ColorsController, type: :controller do
  let(:current_user) { FactoryBot.create(:admin) }

  before do
    allow(User).to receive(:current).and_return current_user
  end

  describe 'index.html' do
    def fetch
      get 'index'
    end
    it_should_behave_like 'a controller action with require_admin'
  end

  describe 'new.html' do
    def fetch
      get 'new'
    end
    it_should_behave_like 'a controller action with require_admin'
  end

  describe 'create.html' do
    def fetch
      post 'create', params: { color: FactoryBot.build(:color).attributes }
    end

    def expect_redirect_to
      Regexp.new(colors_path)
    end
    it_should_behave_like 'a controller action with require_admin'
  end

  describe 'edit.html' do
    def fetch
      @available_color = FactoryBot.create(:color, id: '1337')
      get 'edit', params: { id: '1337' }
    end
    it_should_behave_like 'a controller action with require_admin'
  end

  describe 'update.html' do
    def fetch
      @available_color = FactoryBot.create(:color, id: '1337')
      put 'update', params: { id: '1337', color: { 'name' => 'blubs' } }
    end

    def expect_redirect_to
      colors_path
    end
    it_should_behave_like 'a controller action with require_admin'
  end

  describe 'confirm_destroy.html' do
    def fetch
      @available_color = FactoryBot.create(:color, id: '1337')
      get 'confirm_destroy', params: { id: '1337' }
    end
    it_should_behave_like 'a controller action with require_admin'
  end

  describe 'destroy.html' do
    def fetch
      @available_color = FactoryBot.create(:color, id: '1337')
      post 'destroy', params: { id: '1337' }
    end

    def expect_redirect_to
      colors_path
    end
    it_should_behave_like 'a controller action with require_admin'
  end
end
