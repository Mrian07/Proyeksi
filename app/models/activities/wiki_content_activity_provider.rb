#-- encoding: UTF-8



class Activities::WikiContentActivityProvider < Activities::BaseActivityProvider
  activity_provider_for type: 'wiki_edits',
                        permission: :view_wiki_edits

  def extend_event_query(query)
    query.join(wiki_pages_table).on(activity_journals_table[:page_id].eq(wiki_pages_table[:id]))
    query.join(wikis_table).on(wiki_pages_table[:wiki_id].eq(wikis_table[:id]))
  end

  def event_query_projection
    [
      projection_statement(wikis_table, :project_id, 'project_id'),
      projection_statement(wiki_pages_table, :title, 'wiki_title'),
      projection_statement(wiki_pages_table, :slug, 'wiki_slug')
    ]
  end

  def projects_reference_table
    wikis_table
  end

  protected

  def event_title(event)
    "#{I18n.t(:label_wiki_edit)}: #{event['wiki_title']} (##{event['version']})"
  end

  def event_type(_event)
    'wiki-page'
  end

  def event_path(event)
    url_helpers.project_wiki_path(*url_helper_parameter(event))
  end

  def event_url(event)
    url_helpers.project_wiki_url(*url_helper_parameter(event))
  end

  private

  def wiki_pages_table
    @wiki_pages_table ||= WikiPage.arel_table
  end

  def wikis_table
    @wikis_table ||= Wiki.arel_table
  end

  def url_helper_parameter(event)
    [event['project_id'], event['wiki_slug'], { version: event['version'] }]
  end
end
