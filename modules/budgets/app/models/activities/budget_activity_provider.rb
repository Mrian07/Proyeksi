

class Activities::BudgetActivityProvider < Activities::BaseActivityProvider
  activity_provider_for type: 'budgets',
                        permission: :view_budgets

  def event_query_projection
    [
      activity_journal_projection_statement(:subject, 'budget_subject'),
      activity_journal_projection_statement(:project_id, 'project_id')
    ]
  end

  def event_type(_event)
    'budget'
  end

  def event_title(event)
    "#{I18n.t(:label_budget)} ##{event['journable_id']}: #{event['budget_subject']}"
  end

  def event_path(event)
    url_helpers.budget_path(url_helper_parameter(event))
  end

  def event_url(event)
    url_helpers.budget_url(url_helper_parameter(event))
  end

  private

  def url_helper_parameter(event)
    event['journable_id']
  end
end
