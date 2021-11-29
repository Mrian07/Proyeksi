#-- encoding: UTF-8



class GithubPullRequest < ApplicationRecord
  LABEL_KEYS = %w[color name].freeze

  has_and_belongs_to_many :work_packages
  has_many :github_check_runs, dependent: :destroy
  belongs_to :github_user, optional: true
  belongs_to :merged_by, optional: true, class_name: 'GithubUser'

  enum state: {
    open: 'open',
    closed: 'closed'
  }

  validates_presence_of :github_html_url,
                        :number,
                        :repository,
                        :state,
                        :title,
                        :github_updated_at
  validates_presence_of :body,
                        :comments_count,
                        :review_comments_count,
                        :additions_count,
                        :deletions_count,
                        :changed_files_count,
                        unless: :partial?
  validate :validate_labels_schema

  scope :without_work_package, -> { left_outer_joins(:work_packages).where(work_packages: { id: nil }) }

  def self.find_by_github_identifiers(id: nil, url: nil, initialize: false)
    raise ArgumentError, "needs an id or an url" if id.nil? && url.blank?

    found = where(github_id: id).or(where(github_html_url: url)).take

    if found
      found
    elsif initialize
      new(github_id: id, github_html_url: url)
    end
  end

  ##
  # When a PR lives long enough and receives many pushes, the same check (say, a CI test run) can be run multiple times.
  # This method only returns the latest of each type of check_run.
  def latest_check_runs
    github_check_runs.select("DISTINCT ON (github_check_runs.app_id, github_check_runs.name) *")
                     .order(app_id: :asc, name: :asc, started_at: :desc)
  end

  def partial?
    [body, comments_count, review_comments_count, additions_count, deletions_count, changed_files_count].all?(&:nil?)
  end

  private

  def validate_labels_schema
    return if labels.nil?
    return if labels.all? { |label| label.keys.sort == LABEL_KEYS }

    errors.add(:labels, 'invalid schema')
  end
end
