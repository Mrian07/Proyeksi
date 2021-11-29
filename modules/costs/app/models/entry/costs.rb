#-- encoding: UTF-8



module Entry::Costs
  extend ActiveSupport::Concern

  included do
    def real_costs
      # This methods returns the actual assigned costs of the entry
      overridden_costs || costs || calculated_costs
    end

    def calculated_costs(rate_attr = nil)
      rate_attr ||= current_rate
      cost_attribute * rate_attr.rate
    rescue StandardError
      0.0
    end

    def update_costs(rate_attr = nil)
      rate_attr ||= current_rate
      if rate_attr.nil?
        self.costs = 0.0
        self.rate = nil
        return
      end

      self.costs = calculated_costs(rate_attr)
      self.rate = rate_attr
    end

    def update_costs!(rate_attr = nil)
      update_costs(rate_attr)

      save!
    end

    def cost_attribute
      raise NotImplementedError
    end
  end
end
