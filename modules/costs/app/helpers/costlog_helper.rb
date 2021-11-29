

module CostlogHelper
  def cost_types_collection_for_select_options(selected_type = nil)
    cost_types = CostType.active.sort

    if selected_type && !cost_types.include?(selected_type)
      cost_types << selected_type
      cost_types.sort
    end
    cost_types.map { |t| [t.name, t.id] }
  end

  def user_collection_for_select_options(_options = {})
    User
      .possible_assignee(@project)
      .map { |t| [t.name, t.id] }
  end

  def extended_progress_bar(pcts, options = {})
    return progress_bar(pcts, options) unless pcts.is_a?(Numeric) && pcts > 100

    closed = ((100.0 / pcts) * 100).round
    done = 100.0 - ((100.0 / pcts) * 100).round
    progress_bar([closed, done], options)
  end
end
