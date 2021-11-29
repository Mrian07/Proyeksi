#-- encoding: UTF-8



class GithubCheckRun < ApplicationRecord
  belongs_to :github_pull_request, touch: true

  enum status: {
    completed: 'completed',
    in_progress: 'in_progress',
    queued: 'queued'
  }

  enum conclusion: {
    action_required: 'action_required',
    cancelled: 'cancelled',
    failure: 'failure',
    neutral: 'neutral',
    skipped: 'skipped',
    stale: 'stale',
    success: 'success',
    timed_out: 'timed_out'
  }

  validates_presence_of :github_app_owner_avatar_url,
                        :github_html_url,
                        :github_id,
                        :status,
                        :name
end
