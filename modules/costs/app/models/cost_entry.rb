

class CostEntry < ApplicationRecord
  belongs_to :project
  belongs_to :work_package
  belongs_to :user
  include ::Costs::DeletedUserFallback
  belongs_to :cost_type
  belongs_to :budget
  belongs_to :rate, class_name: 'CostRate'

  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :work_package_id, :project_id, :user_id, :cost_type_id, :units, :spent_on
  validates_numericality_of :units, allow_nil: false, message: :invalid
  validates_length_of :comments, maximum: 255, allow_nil: true

  before_save :before_save
  before_validation :before_validation
  after_initialize :after_initialize
  validate :validate

  scope :on_work_packages, ->(work_packages) { where(work_package_id: work_packages) }

  extend CostEntryScopes
  include Entry::Costs
  include Entry::SplashedDates

  def after_initialize
    if new_record? && cost_type.nil? && default_cost_type = CostType.default
      self.cost_type_id = default_cost_type.id
    end
  end

  def before_validation
    self.project = work_package.project if work_package && project.nil?
  end

  def validate
    errors.add :units, :invalid if units&.negative?
    errors.add :project_id, :invalid if project.nil?
    errors.add :work_package_id, :invalid if work_package.nil? || (project != work_package.project)
    errors.add :cost_type_id, :invalid if cost_type.present? && cost_type.deleted_at.present?
    errors.add :user_id, :invalid if project.present? && !project.users.include?(user) && user_id_changed?

    begin
      spent_on.to_date
    rescue StandardError
      errors.add :spent_on, :invalid
    end
  end

  def before_save
    self.spent_on &&= spent_on.to_date
    update_costs
  end

  def overwritten_costs=(costs)
    write_attribute(:overwritten_costs, CostRate.parse_number_string_to_number(costs))
  end

  def units=(units)
    write_attribute(:units, CostRate.parse_number_string(units))
  end

  def current_rate
    cost_type.rate_at(self.spent_on)
  end

  # Returns true if the cost entry can be edited by usr, otherwise false
  def editable_by?(usr)
    usr.allowed_to?(:edit_cost_entries, project) ||
      (usr.allowed_to?(:edit_own_cost_entries, project) && user_id == usr.id)
  end

  def creatable_by?(usr)
    usr.allowed_to?(:log_costs, project) ||
      (usr.allowed_to?(:log_own_costs, project) && user_id == usr.id)
  end

  def costs_visible_by?(usr)
    usr.allowed_to?(:view_cost_rates, project) ||
      (usr.id == user_id && !overridden_costs.nil?)
  end

  private

  def cost_attribute
    units
  end
end
