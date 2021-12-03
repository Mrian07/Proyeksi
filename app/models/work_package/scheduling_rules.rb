#-- encoding: UTF-8

module WorkPackage::SchedulingRules
  extend ActiveSupport::Concern

  def schedule_automatically?
    !schedule_manually?
  end

  # TODO: move into work package contract (possibly a module included into the contract)
  # Calculates the minimum date that
  # will not violate the precedes relations (max(finish date, start date) + delay)
  # of this work package or its ancestors
  # e.g.
  # AP(due_date: 2017/07/24, delay: 1)-precedes-A
  #                                             |
  #                                           parent
  #                                             |
  # BP(due_date: 2017/07/22, delay: 2)-precedes-B
  #                                             |
  #                                           parent
  #                                             |
  # CP(due_date: 2017/07/25, delay: 2)-precedes-C
  #
  # Then soonest_start for:
  #   C is 2017/07/27
  #   B is 2017/07/25
  #   A is 2017/07/25
  def soonest_start
    # eager load `to` to avoid n+1 on successor_soonest_start
    @soonest_start ||=
      Relation
        .follows_non_manual_ancestors(self)
        .includes(:to)
        .map(&:successor_soonest_start)
        .compact
        .max
  end

  # Returns the time scheduled for this work package.
  #
  # Example:
  #   Start Date: 2/26/09, Finish Date: 3/04/09,  duration => 7
  #   Start Date: 2/26/09, Finish Date: 2/26/09,  duration => 1
  #   Start Date: 2/26/09, Finish Date: -      ,  duration => 1
  #   Start Date: -      , Finish Date: 2/26/09,  duration => 1
  def duration
    if start_date && due_date
      due_date - start_date + 1
    else
      1
    end
  end
end
