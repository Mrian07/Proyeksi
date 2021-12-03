

require 'spec_helper'

describe AdminController, type: :controller do
  let(:user) { FactoryBot.build :admin }

  before do
    allow(User).to receive(:current).and_return user
  end

  describe '#index' do
    it 'renders index' do
      get :index

      expect(response).to be_successful
      expect(response).to render_template 'index'
    end

    describe "with a plugin adding a menu item" do
      render_views

      let(:visible) { true }
      let(:plugin_name) { nil }

      before do
        show = visible
        name = plugin_name

        Redmine::Plugin.register name.to_sym do
          menu :admin_menu,
               :"#{name}_settings",
               { controller: '/admin/settings', action: :show_plugin, id: :"proyeksiapp_#{name}" },
               caption: name.capitalize,
               icon: 'icon2 icon-arrow',
               if: ->(*) { show }
        end

        get :index
      end

      context "with the menu item visible" do
        let(:plugin_name) { "Apple" }
        let(:visible) { true }

        it "should show the plugin in the overview" do
          expect(response.body).to have_selector('a.menu-block', text: plugin_name.capitalize)
        end
      end

      context "with the menu item hidden" do
        let(:plugin_name) { "Orange" }
        let(:visible) { false }

        it "should not show the plugin in the overview" do
          expect(response.body).not_to have_selector('a.menu-block', text: plugin_name.capitalize)
        end
      end
    end
  end

  describe '#plugins' do
    render_views

    context 'with plugins' do
      before do
        Redmine::Plugin.register :foo do end
        Redmine::Plugin.register :bar do end
      end

      it 'renders the plugins' do
        get :plugins

        expect(response).to be_successful
        expect(response).to render_template 'plugins'

        expect(response.body).to have_selector('td span', text: 'Foo')
        expect(response.body).to have_selector('td span', text: 'Bar')
      end
    end

    context 'without plugins' do
      before do
        Redmine::Plugin.clear
      end

      it 'renders even without plugins' do
        get :plugins
        expect(response).to be_successful
        expect(response).to render_template 'plugins'
      end
    end
  end

  describe '#info' do
    it 'renders info' do
      get :info

      expect(response).to be_successful
      expect(response).to render_template 'info'
    end
  end
end
