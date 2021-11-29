

require 'spec_helper'

describe 'Show the date of a Work Package', type: :feature, js: true do
  let(:project) { FactoryBot.create :project }
  let(:admin) { FactoryBot.create :admin }
  let(:work_package) do
    FactoryBot.create :work_package,
                      project: project,
                      due_date: Date.yesterday,
                      type: type,
                      status: open_status
  end

  let(:open_status) { FactoryBot.create :default_status }
  let(:closed_status) { FactoryBot.create :closed_status }

  let(:wp_page) { Pages::FullWorkPackage.new(work_package, project) }

  let(:type) { FactoryBot.create :type }
  let!(:workflow) do
    FactoryBot.create :workflow,
                      type_id: type.id,
                      old_status: open_status,
                      new_status: closed_status
  end

  context 'with an overdue date' do
    before do
      login_as(admin)
      wp_page.visit!
    end

    it 'should be highlighted only if the WP status is open (#33457)' do
      # Highlighted with an open status
      expect(page).to have_selector('.inline-edit--display-field.combinedDate .__hl_date_overdue')

      # Change status to closed
      status_field = WorkPackageStatusField.new(page)
      status_field.update(closed_status.name)

      # Not highlighted with a closed status
      expect(page).not_to have_selector('.inline-edit--display-field.combinedDate .__hl_date_overdue')
    end
  end
end
