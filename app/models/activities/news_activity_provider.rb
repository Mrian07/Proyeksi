#-- encoding: UTF-8

class Activities::NewsActivityProvider < Activities::BaseActivityProvider
  activity_provider_for type: 'news',
                        permission: :view_news

  def event_query_projection
    [
      activity_journal_projection_statement(:title, 'title'),
      activity_journal_projection_statement(:project_id, 'project_id')
    ]
  end

  protected

  def event_title(event)
    event['title']
  end

  def event_type(_event)
    'news'
  end

  def event_path(event)
    url_helpers.news_path(url_helper_parameter(event))
  end

  def event_url(event)
    url_helpers.news_url(url_helper_parameter(event))
  end

  private

  def url_helper_parameter(event)
    event['journable_id']
  end
end
