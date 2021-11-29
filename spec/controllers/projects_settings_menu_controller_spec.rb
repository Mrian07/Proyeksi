

require 'spec_helper'

describe Projects::Settings::ModulesController, 'menu', type: :controller do
  let(:current_user) do
    FactoryBot.build_stubbed(:user).tap do |u|
      allow(u)
        .to receive(:allowed_to?)
        .and_return(true)
    end
  end
  let(:project) do
    # project contains wiki by default
    FactoryBot.create(:project, enabled_module_names: enabled_modules).tap(&:reload)
  end
  let(:enabled_modules) { %w[wiki] }
  let(:params) { { project_id: project.id } }

  before do
    login_as(current_user)
  end

  shared_examples_for 'renders the modules show page' do
    it 'renders show' do
      get 'show', params: params
      expect(response).to be_successful
      expect(response).to render_template 'projects/settings/modules/show'
    end
  end

  shared_examples_for 'has selector' do |selector|
    render_views

    it do
      get 'show', params: params

      expect(response.body).to have_selector selector
    end
  end

  shared_examples_for 'has no selector' do |selector|
    render_views

    it do
      get 'show', params: params

      expect(response.body).not_to have_selector selector
    end
  end

  describe 'show' do
    describe 'without wiki' do
      before do
        project.wiki.destroy
        project.reload
      end

      it_behaves_like 'renders the modules show page'

      it_behaves_like 'has no selector', '#main-menu a.wiki-wiki-menu-item'
    end

    describe 'with wiki' do
      describe 'without custom wiki menu items' do
        it_behaves_like 'has selector', '#main-menu a.wiki-wiki-menu-item'
      end

      describe 'with custom wiki menu item' do
        before do
          main_item = FactoryBot.create(:wiki_menu_item,
                                        navigatable_id: project.wiki.id,
                                        name: 'example',
                                        title: 'Example Title')
          FactoryBot.create(:wiki_menu_item,
                            navigatable_id: project.wiki.id,
                            name: 'sub',
                            title: 'Sub Title',
                            parent_id: main_item.id)
        end

        it_behaves_like 'renders the modules show page'

        it_behaves_like 'has selector', '#main-menu a.wiki-example-menu-item'

        it_behaves_like 'has selector', '#main-menu a.wiki-sub-menu-item'
      end
    end

    describe 'with activated activity module' do
      let(:enabled_modules) { %w[activity] }

      it_behaves_like 'renders the modules show page'

      it_behaves_like 'has selector', '#main-menu a.activity-menu-item'
    end

    describe 'without activated activity module' do
      it_behaves_like 'renders the modules show page'

      it_behaves_like 'has no selector', '#main-menu a.activity-menu-item'
    end
  end
end
