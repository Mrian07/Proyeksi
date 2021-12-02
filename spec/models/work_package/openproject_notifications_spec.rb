#-- encoding: UTF-8



require 'spec_helper'

##
# Tests that email notifications will be sent upon creating or changing a work package.
describe WorkPackage, type: :model, with_settings: { journal_aggregation_time_minutes: 0 } do
  describe 'ProyeksiApp notifications' do
    shared_let(:admin) { FactoryBot.create :admin }

    let(:project) { FactoryBot.create :project }
    let(:work_package) do
      FactoryBot.create :work_package,
                        author: admin,
                        subject: 'I can see you',
                        project: project
    end

    let(:journal_ids) { [] }

    let!(:subscription) do
      ProyeksiApp::Notifications.subscribe(ProyeksiApp::Events::AGGREGATED_WORK_PACKAGE_JOURNAL_READY) do |payload|
        journal_ids << payload[:journal].id
      end
    end

    after do
      ProyeksiApp::Notifications.unsubscribe(ProyeksiApp::Events::AGGREGATED_WORK_PACKAGE_JOURNAL_READY, subscription)
    end

    context 'when after creation' do
      before do
        work_package
        perform_enqueued_jobs
      end

      it "are triggered" do
        expect(journal_ids).to include(work_package.journals.last.id)
      end
    end

    describe 'when after update' do
      before do
        work_package

        journal_ids.clear

        work_package.update subject: 'the wind of change'

        perform_enqueued_jobs
      end

      it "are triggered" do
        expect(journal_ids).to include(work_package.journals.last.id)
      end
    end
  end
end
