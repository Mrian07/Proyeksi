

class MaterialBudgetItem < ApplicationRecord
  belongs_to :budget
  belongs_to :cost_type

  validates_length_of :comments, maximum: 255, allow_nil: true
  validates_presence_of :cost_type

  include ActiveModel::ForbiddenAttributesProtection

  def self.visible(user)
    includes(budget: :project)
      .references(:projects)
      .merge(Project.allowed_to(user, :view_cost_rates))
  end

  scope :visible_costs, lambda { |*args|
    scope = visible(args.first || User.current)

    if args[1]
      scope = scope.where(budget: { projects_id: args[1].id })
    end

    scope
  }

  def costs
    amount || calculated_costs
  end

  def overridden_costs?
    amount.present?
  end

  def calculated_costs(fixed_date = budget.fixed_date)
    if units && cost_type && rate = cost_type.rate_at(fixed_date)
      rate.rate * units
    else
      0.0
    end
  end

  def costs_visible_by?(usr)
    usr.allowed_to?(:view_cost_rates, budget.project)
  end
end
