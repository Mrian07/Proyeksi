

class Activities::DocumentActivityProvider < Activities::BaseActivityProvider
  activity_provider_for type: 'documents',
                        permission: :view_documents

  def event_query_projection
    [
      activity_journal_projection_statement(:title, 'document_title'),
      activity_journal_projection_statement(:project_id, 'project_id')
    ]
  end

  def event_title(event)
    "#{Document.model_name.human}: #{event['document_title']}"
  end

  def event_type(_event)
    'document'
  end

  def event_path(event)
    url_helpers.document_url(url_helper_parameter(event))
  end

  def event_url(event)
    url_helpers.document_url(url_helper_parameter(event))
  end

  private

  def url_helper_parameter(event)
    event['journable_id']
  end
end
