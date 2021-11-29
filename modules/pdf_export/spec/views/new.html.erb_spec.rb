

require 'spec_helper'

describe 'export_card_configurations/new', type: :view do
  let(:config) { FactoryBot.build(:export_card_configuration) }

  before do
    assign(:config, config)
  end

  it 'shows new export card configuration empty inputs' do
    render

    expect(rendered).to have_css("input#export_card_configuration_name")
    expect(rendered).to have_css("input#export_card_configuration_per_page")
    expect(rendered).to have_css("input#export_card_configuration_page_size")
    expect(rendered).to have_css("select#export_card_configuration_orientation")
    expect(rendered).to have_css("textarea#export_card_configuration_rows")
  end
end
