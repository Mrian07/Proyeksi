#-- encoding: UTF-8



require 'spec_helper'

describe Journals::CompletedJob, type: :model do
  let(:send_mail) { true }

  let(:journal) do
    FactoryBot.build_stubbed(:journal, journable: journable).tap do |j|
      allow(Journal)
        .to receive(:find)
              .with(j.id.to_s)
              .and_return(j)
      allow(Journal)
        .to receive(:find_by)
              .with(id: j.id)
              .and_return(j)
      allow(Journal)
        .to receive(:exists?)
              .with(id: j.id)
              .and_return(true)
    end
  end

  describe '.schedule' do
    subject { described_class.schedule(journal, send_mail) }

    shared_examples_for 'enqueues a JournalCompletedJob' do
      before do
        allow(Time)
          .to receive(:current)
                .and_return(Time.current)
      end

      it 'enqueues a JournalCompletedJob' do
        expect { subject }
          .to have_enqueued_job(described_class)
                .at(Setting.journal_aggregation_time_minutes.to_i.minutes.from_now)
                .with(journal.id,
                      send_mail)
      end
    end

    shared_examples_for 'enqueues no job' do
      it 'enqueues no JournalCompletedJob' do
        expect { subject }
          .not_to have_enqueued_job(described_class)
      end
    end

    context 'with a work_package' do
      let(:journable) { FactoryBot.build_stubbed(:work_package) }

      it_behaves_like 'enqueues a JournalCompletedJob'
    end

    context 'with a wiki page' do
      let(:journable) { FactoryBot.build_stubbed(:wiki_content) }

      it_behaves_like 'enqueues a JournalCompletedJob'
    end

    context 'with a news' do
      let(:journable) { FactoryBot.build_stubbed(:news) }

      it_behaves_like 'enqueues a JournalCompletedJob'
    end
  end

  describe '#perform' do
    subject { described_class.new.perform(journal.id, send_mail) }

    shared_examples_for 'sends a notification' do |event|
      it 'sends a notification' do
        allow(ProyeksiApp::Notifications)
          .to receive(:send)

        subject

        expect(ProyeksiApp::Notifications)
          .to have_received(:send)
                .with(event,
                      journal: journal,
                      send_mail: send_mail)
      end
    end

    context 'with a work packages' do
      let(:journable) { FactoryBot.build_stubbed(:work_package) }

      it_behaves_like 'sends a notification',
                      ProyeksiApp::Events::AGGREGATED_WORK_PACKAGE_JOURNAL_READY
    end

    context 'with wiki page content' do
      let(:journable) { FactoryBot.build_stubbed(:wiki_content) }

      it_behaves_like 'sends a notification',
                      ProyeksiApp::Events::AGGREGATED_WIKI_JOURNAL_READY
    end

    context 'with a news' do
      let(:journable) { FactoryBot.build_stubbed(:news) }

      it_behaves_like 'sends a notification',
                      ProyeksiApp::Events::AGGREGATED_NEWS_JOURNAL_READY
    end

    context 'with a non non-existant journal' do
      let(:journable) { FactoryBot.build_stubbed(:work_package) }

      before do
        allow(Journal)
          .to receive(:find_by)
                .with(id: journal.id)
                .and_return(nil)
      end

      it 'sends no notification' do
        allow(ProyeksiApp::Notifications)
          .to receive(:send)

        subject

        expect(ProyeksiApp::Notifications)
          .not_to have_received(:send)
      end
    end
  end
end
