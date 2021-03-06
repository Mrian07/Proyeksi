

require 'spec_helper'

describe MenuItem, type: :model do
  describe 'validations' do
    let(:item) { FactoryBot.build :menu_item }

    it 'requires a title' do
      item.title = nil
      expect(item).not_to be_valid
      expect(item.errors).to have_key :title
    end

    it 'requires a name' do
      item.name = nil
      expect(item).not_to be_valid
      expect(item.errors).to have_key :name
    end

    describe 'scoped uniqueness of title' do
      let!(:item) { FactoryBot.create :menu_item }
      let(:another_item) { FactoryBot.build :menu_item, title: item.title }
      let(:wiki_menu_item) { FactoryBot.build :wiki_menu_item, title: item.title }

      it 'does not allow for duplicate titles' do
        expect(another_item).not_to be_valid
        expect(another_item.errors).to have_key :title
      end

      it 'allows for creating a menu item with the same title if it has a different type' do
        expect(wiki_menu_item).to be_valid
      end
    end
  end

  context 'it should destroy' do
    let!(:menu_item) { FactoryBot.create(:menu_item) }
    let!(:child_item) { FactoryBot.create(:menu_item, parent_id: menu_item.id) }

    example 'all children when deleting the parent' do
      menu_item.destroy
      expect(MenuItem.exists?(child_item.id)).to be_falsey
    end
  end
end
