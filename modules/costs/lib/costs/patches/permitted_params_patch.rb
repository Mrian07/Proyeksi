

module Costs::Patches::PermittedParamsPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def cost_entry
      params.require(:cost_entry).permit(:comments,
                                         :units,
                                         :overridden_costs,
                                         :spent_on)
    end

    def budget
      params.require(:budget).permit(:subject,
                                     :description,
                                     :fixed_date,
                                     { new_material_budget_item_attributes: %i[units cost_type_id comments amount] },
                                     { new_labor_budget_item_attributes: %i[hours user_id comments amount] },
                                     { existing_material_budget_item_attributes: %i[units cost_type_id comments amount] },
                                     existing_labor_budget_item_attributes: %i[hours user_id comments amount])
    end

    def cost_type
      params.require(:cost_type).permit(:name,
                                        :unit,
                                        :unit_plural,
                                        :default,
                                        { new_rate_attributes: %i[valid_from rate] },
                                        existing_rate_attributes: %i[valid_from rate])
    end

    def user_rates
      params.require(:user).permit(new_rate_attributes: %i[valid_from rate],
                                   existing_rate_attributes: %i[valid_from rate])
    end
  end
end
