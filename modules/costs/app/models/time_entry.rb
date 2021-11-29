#-- encoding: UTF-8



class TimeEntry < ApplicationRecord
  # could have used polymorphic association
  # project association here allows easy loading of time entries at project level with one database trip
  belongs_to :project
  belongs_to :work_package
  belongs_to :user
  belongs_to :activity, class_name: 'TimeEntryActivity'
  belongs_to :rate, -> { where(type: %w[HourlyRate DefaultHourlyRate]) }, class_name: 'Rate'

  acts_as_customizable

  acts_as_journalized

  validates_presence_of :user_id, :activity_id, :project_id, :hours, :spent_on
  validates_numericality_of :hours, allow_nil: true, message: :invalid
  validates_length_of :comments, maximum: 255, allow_nil: true

  scope :on_work_packages, ->(work_packages) { where(work_package_id: work_packages) }

  include ::Scopes::Scoped
  extend ::TimeEntries::TimeEntryScopes
  include Entry::Costs
  include Entry::SplashedDates

  scopes :of_user_and_day,
         :visible

  # TODO: move into service
  before_save :update_costs

  def self.update_all(updates, conditions = nil, options = {})
    # instead of a update_all, perform an individual update during work_package#move
    # to trigger the update of the costs based on new rates
    if conditions.respond_to?(:keys) && conditions.keys == [:work_package_id] && updates =~ /^project_id = (\d+)$/
      project_id = $1
      time_entries = TimeEntry.where(conditions)
      time_entries.each do |entry|
        entry.project_id = project_id
        entry.save!
      end
    else
      super
    end
  end

  def hours=(value)
    write_attribute :hours, (value.is_a?(String) ? (value.to_hours || value) : value)
  end

  # Returns true if the time entry can be edited by usr, otherwise false
  def editable_by?(usr)
    (usr == user && usr.allowed_to?(:edit_own_time_entries, project)) || usr.allowed_to?(:edit_time_entries, project)
  end

  def current_rate
    user.rate_at(spent_on, project_id)
  end

  def visible_by?(usr)
    usr.allowed_to?(:view_time_entries, project) ||
      (user_id == usr.id && usr.allowed_to?(:view_own_time_entries, project))
  end

  def costs_visible_by?(usr)
    usr.allowed_to?(:view_hourly_rates, project) ||
      (user_id == usr.id && usr.allowed_to?(:view_own_hourly_rate, project))
  end

  private

  def cost_attribute
    hours
  end
end
