

class LaborBudgetItem < ApplicationRecord
  belongs_to :budget
  belongs_to :user
  belongs_to :principal, foreign_key: 'user_id'

  include ::Costs::DeletedUserFallback

  validates_length_of :comments, maximum: 255, allow_nil: true
  validates_presence_of :user
  validates_presence_of :budget
  validates_numericality_of :hours, allow_nil: false

  include ActiveModel::ForbiddenAttributesProtection
  # user_id correctness is ensured in Budget#*_labor_budget_item_attributes=

  def self.visible(user, project)
    table = arel_table

    view_allowed = Project.allowed_to(user, :view_hourly_rates).select(:id)
    view_own_allowed = Project.allowed_to(user, :view_own_hourly_rate).select(:id)

    view_or_view_own = table[:project_id]
                       .in(view_allowed.arel)
                       .or(table[:project_id]
                           .in(view_own_allowed.arel)
                           .and(table[:user_id].eq(user.id)))

    scope = includes([{ budget: :project }, :user])
            .references(:projects)
            .where(view_or_view_own)

    if project
      scope.where(budget: { projects_id: project.id })
    end
  end

  scope :visible_costs, lambda { |*args|
    visible((args.first || User.current), args[1])
  }

  def costs
    amount || calculated_costs
  end

  def overridden_costs?
    amount.present?
  end

  def calculated_costs(fixed_date = budget.fixed_date, project_id = budget.project_id)
    if user_id && hours && (rate = HourlyRate.at_date_for_user_in_project(fixed_date, user_id, project_id))
      rate.rate * hours
    else
      0.0
    end
  end

  def costs_visible_by?(usr)
    usr.allowed_to?(:view_hourly_rates, budget.project) ||
      (usr.id == user_id && usr.allowed_to?(:view_own_hourly_rate, budget.project))
  end
end
