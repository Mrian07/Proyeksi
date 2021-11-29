

require 'spec_helper'

describe 'export_card_configurations/index', type: :view do
  let(:config1) { FactoryBot.build(:export_card_configuration, name: "Config 1") }
  let(:config2) { FactoryBot.build(:export_card_configuration, name: "Config 2") }

  before do
    config1.save
    config2.save
    assign(:configs, [config1, config2])
  end

  it 'shows export card configurations' do
    render

    expect(rendered).to have_selector("a", text: config1.name)
    expect(rendered).to have_selector("a", text: config2.name)
  end
end
