

require 'spec_helper'

describe Notifications::ScheduleReminderMailsJob, type: :job do
  subject(:job) { scheduled_job.invoke_job }

  let(:scheduled_job) do
    described_class.ensure_scheduled!

    Delayed::Job.first
  end

  let(:ids) { [23, 42] }
  let(:run_at) { scheduled_job.run_at }

  before do
    # We need to access the job as stored in the database to get at the run_at time persisted there
    allow(ActiveJob::Base)
      .to receive(:queue_adapter)
            .and_return(ActiveJob::QueueAdapters::DelayedJobAdapter.new)

    scheduled_job.update_column(:run_at, run_at)

    scope = instance_double(ActiveRecord::Relation)
    allow(User)
      .to receive(:having_reminder_mail_to_send)
            .and_return(scope)

    allow(scope)
      .to receive(:pluck)
            .with(:id)
            .and_return(ids)
  end

  describe '#perform' do
    shared_examples_for 'schedules reminder mails' do
      it 'schedules reminder jobs for every user with a reminder mails to be sent' do
        expect { subject }
          .to change(Delayed::Job, :count)
                .by(2)

        jobs = Delayed::Job.all.map do |job|
          YAML.safe_load(job.handler, permitted_classes: [ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper])
        end

        reminder_jobs = jobs.select { |job| job.job_data['job_class'] == "Mails::ReminderJob" }

        expect(reminder_jobs[0].job_data['arguments'])
          .to match_array([23])

        expect(reminder_jobs[1].job_data['arguments'])
          .to match_array([42])
      end

      it 'queries with the intended job execution time (which might have been missed due to high load)' do
        subject

        expect(User)
          .to have_received(:having_reminder_mail_to_send)
                .with(run_at)
      end
    end

    it_behaves_like 'schedules reminder mails'

    context 'with a job that missed some runs' do
      let(:run_at) { scheduled_job.run_at - 3.hours }

      it_behaves_like 'schedules reminder mails'
    end
  end
end
