

require 'spec_helper'

describe 'Disabled activity', type: :feature do
  shared_let(:admin) { FactoryBot.create :admin }

  let(:project1) do
    FactoryBot.create(:project, enabled_module_names: %i[work_package_tracking wiki])
  end
  let(:project2) do
    FactoryBot.create(:project, enabled_module_names: %i[work_package_tracking activity wiki])
  end
  let(:project3) do
    FactoryBot.create(:project, enabled_module_names: %i[activity])
  end
  let!(:work_package1) { FactoryBot.create(:work_package, project: project1) }
  let!(:work_package2) { FactoryBot.create(:work_package, project: project2) }
  let!(:work_package3) { FactoryBot.create(:work_package, project: project3) }
  let!(:wiki_page1) do
    FactoryBot.create(:wiki_page, wiki: project1.wiki) do |page|
      FactoryBot.create(:wiki_content, page: page)
    end
  end
  let!(:wiki_page2) do
    FactoryBot.create(:wiki_page, wiki: project2.wiki) do |page|
      FactoryBot.create(:wiki_content, page: page)
    end
  end
  let!(:wiki_page3) do
    wiki = FactoryBot.create(:wiki, project: project3)

    FactoryBot.create(:wiki_page, wiki: wiki) do |page|
      FactoryBot.create(:wiki_content, page: page)
    end
  end

  before do
    login_as(admin)
  end

  it 'does not display activities on projects disabling it' do
    visit activity_index_path

    check "Wiki edits"
    click_on "Apply"

    expect(page)
      .to have_content(work_package2.subject)
    expect(page)
      .to have_content(wiki_page2.title)

    # Not displayed as activity is disabled
    expect(page)
      .not_to have_content(work_package1.subject)
    expect(page)
      .not_to have_content(wiki_page1.title)

    # Not displayed as all modules except activity are disabled
    expect(page)
      .not_to have_content(work_package3.subject)
    expect(page)
      .not_to have_content(wiki_page3.title)
  end
end
