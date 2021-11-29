

require 'spec_helper'

describe 'custom_styles/show', type: :view do
  let(:user) { FactoryBot.build(:admin) }

  before do
    login_as user
  end

  context "no custom logo yet" do
    before do
      assign(:custom_style, CustomStyle.new)
      assign(:current_theme, '')
      allow(view).to receive(:options_for_select).and_return('')
      render
    end

    it 'shows an upload button' do
      expect(rendered).to include "Upload"
    end
  end

  context "with existing custom logo" do
    before do
      assign(:custom_style, FactoryBot.build(:custom_style_with_logo))
      assign(:current_theme, '')
      allow(view).to receive(:options_for_select).and_return('')
      render
    end

    it 'shows a replace button' do
      expect(rendered).to include "Replace"
    end
  end
end
