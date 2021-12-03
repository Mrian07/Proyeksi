

module CostQuery::Cache
  class << self
    def check
      reset! if reset_required?
    end

    def reset!
      update_reset_on

      CostQuery::Filter.reset!
      CostQuery::Filter::CustomFieldEntries.reset!
      CostQuery::GroupBy.reset!
      CostQuery::GroupBy::CustomFieldEntries.reset!
    end

    protected

    attr_accessor :latest_custom_field_change,
                  :custom_field_count

    def invalid?
      changed_on = fetch_latest_custom_field_change
      field_count = fetch_current_custom_field_count

      latest_custom_field_change != changed_on ||
        custom_field_count != field_count
    end

    def update_reset_on
      return if caching_disabled?

      self.latest_custom_field_change = fetch_latest_custom_field_change
      self.custom_field_count = fetch_current_custom_field_count
    end

    def fetch_latest_custom_field_change
      WorkPackageCustomField.maximum(:updated_at)
    end

    def fetch_current_custom_field_count
      WorkPackageCustomField.count
    end

    def caching_disabled?
      !ProyeksiApp::Configuration.cost_reporting_cache_filter_classes
    end

    def reset_required?
      caching_disabled? || invalid?
    end
  end

  # initialize to 0 to avoid forced cache reset on first request
  self.custom_field_count = 0
end
