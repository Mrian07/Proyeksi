#-- encoding: UTF-8



module Budgets
  class BaseContract < ::ModelContract
    include Attachments::ValidateReplacements

    def self.model
      Budget
    end

    attribute :subject
    attribute :description
    attribute :fixed_date
    attribute :project
    attribute :new_material_budget_item_attributes,
              readable: false

    attribute :new_labor_budget_item_attributes,
              readable: false

    attribute :existing_material_budget_item_attributes,
              readable: false

    attribute :existing_labor_budget_item_attributes,
              readable: false

    validate :validate_manage_allowed

    private

    def validate_manage_allowed
      unless user.allowed_to?(:edit_budgets, model.project)
        errors.add :base, :error_unauthorized
      end
    end
  end
end
