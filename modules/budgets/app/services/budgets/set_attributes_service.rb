#-- encoding: UTF-8



module Budgets
  class SetAttributesService < ::BaseServices::SetAttributes
    include Attachments::SetReplacements

    private

    def set_attributes(params)
      set_fixed_date(params)
      unset_items(params)

      super
    end

    def set_default_attributes(_params)
      model.change_by_system do
        model.author = user
      end
    end

    # fixed_date must be set before material_budget_items and labor_budget_items
    def set_fixed_date(params)
      model.fixed_date = params.delete(:fixed_date) || Date.today
    end

    def unset_items(params)
      if params[:existing_material_budget_item_attributes].nil?
        model.existing_material_budget_item_attributes = ({})
      end

      if params[:existing_labor_budget_item_attributes].nil?
        model.existing_labor_budget_item_attributes = ({})
      end
    end
  end
end
