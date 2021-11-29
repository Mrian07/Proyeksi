

require 'spec_helper'

describe MenuItems::QueryMenuItem, type: :model do
  let(:project) { FactoryBot.create :project, enabled_module_names: %w[activity] }
  let(:query) { FactoryBot.create :query, project: project }
  let(:another_query) { FactoryBot.create :query, project: project }

  describe 'it should destroy all items when destroying' do
    before(:each) do
      query_item = FactoryBot.create(:query_menu_item,
                                     query: query,
                                     name: 'Query Item',
                                     title: 'Query Item')
      another_query_item = FactoryBot.create(:query_menu_item,
                                             query: another_query,
                                             name: 'Another Query Item',
                                             title: 'Another Query Item')
    end

    it 'the associated query' do
      query.destroy
      expect(MenuItems::QueryMenuItem.where(navigatable_id: query.id)).to be_empty
    end
  end
end
