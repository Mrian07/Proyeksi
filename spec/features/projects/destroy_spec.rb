

require 'spec_helper'

describe 'Projects#destroy',
         type: :feature,
         js: true do
  let!(:project) { FactoryBot.create(:project, name: 'foo', identifier: 'foo') }
  let(:project_page) { Pages::Projects::Destroy.new(project) }
  let(:danger_zone) { DangerZone.new(page) }

  current_user { FactoryBot.create(:admin) }

  before do
    # Disable background worker
    allow(Delayed::Worker)
      .to receive(:delay_jobs)
      .and_return(false)

    project_page.visit!
  end

  it 'destroys the project' do
    # Confirm the deletion
    # Without confirmation, the button is disabled
    expect(danger_zone)
      .to be_disabled

    # With wrong confirmation, the button is disabled
    danger_zone.confirm_with("#{project.identifier}_wrong")

    expect(danger_zone)
      .to be_disabled

    # With correct confirmation, the button is enabled
    # and the project can be deleted
    danger_zone.confirm_with(project.identifier)
    expect(danger_zone).not_to be_disabled
    danger_zone.danger_button.click

    expect(page).to have_selector '.flash.notice', text: I18n.t('projects.delete.scheduled')

    perform_enqueued_jobs

    expect { project.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
