

require 'spec_helper'

describe 'export_card_configurations/edit', type: :view do
  let(:config) { FactoryBot.build(:export_card_configuration) }

  before do
    config.save
    assign(:config, config)
  end

  it 'shows edit export card configuration inputs' do
    render

    expect(rendered).to have_field("Name", with: config.name)
    expect(rendered).to have_field("Description", with: config.description)
    expect(rendered).to have_field("Per page", with: config.per_page.to_s)
    expect(rendered).to have_field("Page size", with: config.page_size)
    expect(rendered).to have_field("Orientation", with: config.orientation)
    expect(rendered).to have_field("Rows", with: config.rows)
  end
end
