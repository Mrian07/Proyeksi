

require 'spec_helper'

describe 'wiki/new', type: :view do
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:wiki)    { FactoryBot.build_stubbed(:wiki, project: project) }
  let(:page)    { FactoryBot.build_stubbed(:wiki_page_with_content, wiki: wiki, title: 'foo') }
  let(:content) { page.content }
  let(:user)    { FactoryBot.build_stubbed(:user) }

  before do
    assign(:project, project)
    assign(:wiki,    wiki)
    assign(:page,    page)
    assign(:content, content)
    allow(view)
      .to receive(:current_user)
      .and_return(user)
  end

  it 'renders a form which POSTs to create_project_wiki_index_path' do
    project.identifier = 'my_project'
    render
    assert_select 'form',
                  action: create_project_wiki_index_path(project_id: project),
                  method: 'post'
  end

  it 'contains an input element for title' do
    page.title = 'Boogie'

    render
    assert_select 'input', name: 'page[title]', value: 'Boogie'
  end

  it 'contains an input element for parent page' do
    page.parent_id = 123

    render
    assert_select 'input', name: 'page[parent_id]', value: '123', type: 'hidden'
  end
end
