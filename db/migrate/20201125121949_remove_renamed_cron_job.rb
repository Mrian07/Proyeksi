#-- encoding: UTF-8

class RemoveRenamedCronJob < ActiveRecord::Migration[6.0]
  def up
    # The job has been renamed to JobStatus::Cron::ClearOldJobStatusJob
    # the new job will be added on restarting the application but the old will still be in the database
    # and will cause 'uninitialized constant' errors.
    Delayed::Job
      .where('handler LIKE ?', "%job_class: Cron::ClearOldJobStatusJob%")
      .delete_all
  end
end
