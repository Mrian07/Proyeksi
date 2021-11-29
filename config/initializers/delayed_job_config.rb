#-- encoding: UTF-8



# Disable delayed_job's own logging as we have activejob
Delayed::Worker.logger = nil

# By default bypass worker queue and execute asynchronous tasks at once
Delayed::Worker.delay_jobs = true

# Set default priority (lower = higher priority)
# Example ordering, see ApplicationJob.priority_number
Delayed::Worker.default_priority = ::ApplicationJob.priority_number(:default)

# Do not retry jobs from delayed_job
# instead use 'retry_on' activejob functionality
Delayed::Worker.max_attempts = 1
