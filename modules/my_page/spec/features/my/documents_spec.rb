

require 'spec_helper'

require_relative '../../support/pages/my/page'

describe 'My page documents widget', type: :feature, js: true do
  let!(:project) { FactoryBot.create :project }
  let!(:other_project) { FactoryBot.create :project }
  let!(:visible_document) do
    FactoryBot.create :document,
                      project: project,
                      description: 'blubs'
  end
  let!(:invisible_document) do
    FactoryBot.create :document,
                      project: other_project
  end
  let(:other_user) do
    FactoryBot.create(:user)
  end
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i[view_documents])
  end
  let(:my_page) do
    Pages::My::Page.new
  end

  before do
    login_as user

    my_page.visit!
  end

  it 'can add the widget and see the visible documents' do
    # within top-right area, add an additional widget
    my_page.add_widget(1, 1, :within, 'Documents')

    document_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')
    document_area.expect_to_span(1, 1, 2, 2)

    expect(page)
      .to have_content visible_document.title
    expect(page)
      .to have_content visible_document.description
    expect(page)
      .to have_content visible_document.created_at.strftime('%m/%d/%Y')

    expect(page)
      .to have_no_content invisible_document.title
  end
end
