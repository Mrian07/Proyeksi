

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe 'hourly rates on a member', type: :feature, js: true do
  let(:project) { FactoryBot.build :project }
  let(:user) do
    FactoryBot.create :admin,
                      member_in_project: project
  end
  let(:member) { Member.find_by(project: project, principal: user) }

  def view_rates
    visit edit_user_path(user, tab: 'rates')
  end

  def view_project_members
    visit project_members_path(project)
  end

  def expect_current_rate_in_members_table(amount)
    view_project_members

    expect(page).to have_selector("#member-#{member.id} .currency", text: amount)
  end

  def add_rate(rate:, date: nil)
    expect(page).to have_selector(".add-row-button")
    sleep(0.1)
    all("tr[id^='user_new_rate_attributes_'] .delete-row-button").each(&:click)
    sleep(0.1)
    click_link_or_button 'Add rate'

    within "tr[id^='user_new_rate_attributes_']" do
      fill_in 'Valid from', with: date.strftime('%Y-%m-%d') if date
      fill_in 'Rate', with: rate
    end
  end

  def change_rate_date(from:, to:)
    input = find("table.rates .date[value='#{from.strftime('%Y-%m-%d')}']")
    input.set(to.strftime('%Y-%m-%d'))
  end

  before do
    project.save!

    login_as(user)
  end

  it 'displays always the currently active rate' do
    expect_current_rate_in_members_table('0.00 EUR')

    click_link('0.00 EUR')
    SeleniumHubWaiter.wait

    add_rate(date: Date.today, rate: 10)

    click_button 'Save'

    expect_current_rate_in_members_table('10.00 EUR')

    SeleniumHubWaiter.wait
    click_link('10.00 EUR')

    add_rate(date: 3.days.ago, rate: 20)

    click_button 'Save'

    expect_current_rate_in_members_table('10.00 EUR')

    SeleniumHubWaiter.wait
    click_link('10.00 EUR')

    change_rate_date(from: Date.today, to: 5.days.ago)

    click_button 'Save'

    expect_current_rate_in_members_table('20.00 EUR')
  end
end
