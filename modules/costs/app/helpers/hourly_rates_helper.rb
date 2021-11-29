

module HourlyRatesHelper
  include CostlogHelper

  # Returns the rate that is the closest at the specified date and that is
  # defined in the specified projects or it's ancestors. The ancestor chain
  # is traversed from the specified project upwards.
  #
  # Expects all_rates to be all the rates that the user possibly has
  # grouped by project typically by having called HourlyRates.history_for_user
  #
  # This is faster than calling current_rate for each project
  def at_date_in_project_with_ancestors(at_date, all_rates, project)
    self_and_ancestors = all_rates.keys
                                  .select { |ancestor| ancestor.lft <= project.lft && ancestor.rgt >= project.rgt }
                                  .sort_by(&:lft)
                                  .reverse

    self_and_ancestors.each do |ancestor|
      rate = all_rates[ancestor].select { |rate| rate.valid_from <= at_date }
                                .max_by(&:valid_from)

      return rate if rate
    end

    nil
  end
end
