

class RbTaskboardsController < RbApplicationController
  menu_item :backlogs

  helper :taskboards

  def show
    @statuses     = Type.find(Task.type).statuses
    @story_ids    = @sprint.stories(@project).map(&:id)
    @last_updated = Task.children_of(@story_ids)
                        .order(Arel.sql('updated_at DESC'))
                        .first
  end

  def default_breadcrumb
    I18n.t(:label_backlogs)
  end
end
