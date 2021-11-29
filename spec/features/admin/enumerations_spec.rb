

require 'spec_helper'

describe 'Enumerations', type: :feature do
  shared_let(:admin) { FactoryBot.create :admin }

  before do
    login_as(admin)
    visit enumerations_path
  end

  it 'contains all defined enumerations' do
    Enumeration.subclasses.each do |enumeration|
      expect(page).to have_selector('h3', text: I18n.t(enumeration::OptionName))
      expect(page).to have_link(I18n.t(:label_enumeration_new),
                                href: new_enumeration_path(type: enumeration.name))
    end
  end
end
