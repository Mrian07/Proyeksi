

require 'spec_helper'

describe Wiki, type: :model do
  describe 'creation' do
    let(:project) { FactoryBot.create(:project, disable_modules: 'wiki') }
    let(:start_page) { 'The wiki start page' }

    it_behaves_like 'acts_as_watchable included' do
      let(:model_instance) { FactoryBot.create(:wiki) }
      let(:watch_permission) { :view_wiki_pages }
      let(:project) { model_instance.project }
    end

    describe '#create' do
      let(:wiki) { project.create_wiki start_page: start_page }

      it 'creates a wiki menu item on creation' do
        expect(wiki.wiki_menu_items).to be_one
      end

      it 'sets the wiki menu item title to the name of the start page' do
        expect(wiki.wiki_menu_items.first.title).to eq(start_page)
      end
    end

    describe '#find_page' do
      let(:wiki) { project.create_wiki start_page: start_page }
      let(:wiki_page) { FactoryBot.build(:wiki_page, wiki: wiki, title: 'Übersicht') }

      subject { wiki.find_page('Übersicht') }

      it 'will find the page using the title' do
        wiki_page.save!
        expect(wiki_page.slug).to eq 'ubersicht'
        expect(subject).to eq wiki_page
      end

      context 'with german default_language', with_settings: { default_language: 'de' } do
        it 'will find the page with the default_language slug title (Regression #38606)' do
          wiki_page.save!
          wiki_page.update_column(:slug, 'uebersicht')

          expect(wiki_page.reload.slug).to eq 'uebersicht'
          expect(subject).to eq wiki_page
        end
      end
    end
  end
end
